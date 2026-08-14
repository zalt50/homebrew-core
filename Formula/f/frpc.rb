class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "1dd367d6d822a7fce1d3012fce0a6e778bc90c454e2c7baa0eb1e6de6054c61b"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d256de44d43c63f30fca47636a05df5f915af1a00dad36cfb18a202532034d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d256de44d43c63f30fca47636a05df5f915af1a00dad36cfb18a202532034d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d256de44d43c63f30fca47636a05df5f915af1a00dad36cfb18a202532034d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "8547ee12d1468a2f6ea454e6602759daf531534eaf044bbdcf92c73da4606edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9a17b32139cad6d64aa264aeb9e578fcc9b751f63bcbf0353ecc456e4cd698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c8d48beb8fcad7a598673cee67ff6242bad782bd5a0f8eff51d9996289e066"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build-only"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
