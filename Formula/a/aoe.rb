class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "4e9463d068274607d7409b44ee587b09a373166bdf5989ccc46aea27db83dda6"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e272932b31fa58bc7b3d4c3204681a1c7be983d0f6fef76813feda3f274361ce"
    sha256 cellar: :any,                 arm64_sequoia: "b733b7eff57eb6d3cc61c09849ce70d1a8ada2531250afbc826d41ae669869b6"
    sha256 cellar: :any,                 arm64_sonoma:  "9b39b721b8496daec9973ba6358c391d05c31210323a61864d97b8ce040bb137"
    sha256 cellar: :any,                 sonoma:        "f27f24aa977a2b31512d2ad935798e6598348813b2171b6f2c44f3490833d6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da9dfb271705bb1864f2590472bf523b9011ec190503c7a8961dceba1c11f19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f214559a79b885df1c31d01bfaa5426f1a31830c8fae80da4af6735aea9c6ae"
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
