class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3d46800ef03afd1206c02b91cc544395061de3f17ace8b31ce4290514876f490"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbdac899523c54af79a227a7f46d99e6e1c2480e0fa99b5a6cb1d1293af523af"
    sha256 cellar: :any,                 arm64_sequoia: "b287454db0c1fbd4b3c0016a1d266557bacb90cbe7cf0c7bc64eebc8db30b9aa"
    sha256 cellar: :any,                 arm64_sonoma:  "e627c6c4a5d5a49984e3c46add79db6673d4956cee5bef18001e034abb0a6b66"
    sha256 cellar: :any,                 sonoma:        "da50e14800471d7203783f67622f0cb8145460828fbc24c79a6adc41fd880c47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8db6e19563a3f8179018086e4187717a33632b99a275096076cf186eb387a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2577dcb729265a32992d8a24c606ae3c6a3fe29efaa28aadb8d1bc6cc63af5"
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
