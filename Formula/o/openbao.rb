class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.6.3",
      revision: "63a65e6b907589dbb952c371a70260a065bf8bd7"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7533ffe1f57f4ce7f63a0c76d0da47f839266e11c34fd057757a46ac6cb0d0c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed93e1ef1f2759f68f5769c7d0c2ba2022e2f3c48b8ab5df5f4061bbd2fca03a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d807a7e5c76a27e5b12bbc245d6d6e445841490a8cb48f2bf55c6e976dbb73c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a9553702f5acfbf298bab64785a22c8af75e92e6dbb52719d4149f3fd453b1d"
    sha256 cellar: :any,                 x86_64_linux:      "58720875d7061e20a29efd38bb0cc256727641596a3230ce3f885bf18b492784"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
    end
  end

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      system "pnpm", "--offline", "build"
    end

    ldflags = %W[
      -X github.com/openbao/openbao/version.fullVersion=#{version}
      -X github.com/openbao/openbao/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/version.BuildDate=#{time.iso8601}
    ]
    tags = %w[testonly ui]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"bao")
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"

    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end
