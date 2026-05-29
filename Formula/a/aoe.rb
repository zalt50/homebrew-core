class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "bd075b6482c057912e02436fe90aba9a42341e650b39cbbbb61911bc817fc1b6"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2695ab758644fb506d4dc10876b0e349be5c2d9ad24ac6bbb54951e626fc4f46"
    sha256 cellar: :any,                 arm64_sequoia: "3c959c49980371a10627cd28095601b073b7d04461fb5edb53a326eac37da588"
    sha256 cellar: :any,                 arm64_sonoma:  "7207f0dd2be60672c0a909d1f23c08a7acb7179cb1b4b96ffa9b92460ab0a723"
    sha256 cellar: :any,                 sonoma:        "0a3e1670ffa13d9708b3860055c7c2b30266061d39080dea477e9710827f1900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a97a075226979c0a5c8ca655151fd3427d9016ff280533b75b5a9319b91c260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79775d676aeb8520f856f3051fdf2ba352452db96b707a41a87289f18a832bce"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
