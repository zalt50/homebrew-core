class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.14.1",
      revision: "4adb9cf4bbf21486113eb13680b8be6a08fc5d0e"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31bf2984142ffcf64682ea92bf492d23f05fba5542e2171b48b241da33232b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b49ded77d2e407d9d6b51cd4f6f9ce10c346f065521a13139768c6cb24527db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e98bbd4bd142f61bb5cea67da6fa7890e8f4834aa30fa498c76b5aeacea2770e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6316b92e9f738ad2dfcd3818fa19d602a413cf372e4c7927170798697ff0cafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2677faf32430dc836dbfcfe8aceca16b30af971aab8d17126c91d879f3c09845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca50a8a3660943aa2078516c29dac0d56348272dd716fb05ebdcb43034358f6"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
