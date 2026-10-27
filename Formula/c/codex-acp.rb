class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.3.0.tgz"
  sha256 "01292cc857f03191a72db93055066623aafc6c11e7c5db52f6c4fa7bc8013e86"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58c80665c13798a8f07a07a819d7916fc68f126204319fc50e6232889266fddd"
    sha256 cellar: :any, arm64_tahoe:       "58c80665c13798a8f07a07a819d7916fc68f126204319fc50e6232889266fddd"
    sha256 cellar: :any, arm64_sequoia:     "58c80665c13798a8f07a07a819d7916fc68f126204319fc50e6232889266fddd"
    sha256 cellar: :any, arm64_linux:       "03f0bfbf8dce238e82059e62cd0d5b2ac811195054c9f6fd9154e4ad4804fdac"
    sha256 cellar: :any, x86_64_linux:      "de58e8d65f21bd9b305c217347dd79d89a578a66dcd297b1fbbb033063cf000b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    rm libexec.glob("lib/node_modules/**/codex-resources/zsh/bin/zsh") if OS.linux?
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _e, w|
      stdin.write json
      sleep 3
      output = stdout.readline
      assert_match("\"protocolVersion\":1", output)
      assert_match("\"agentInfo\":{\"name\":\"@agentclientprotocol/codex-acp\"", output)
      Process.kill("KILL", w.pid)
    end
  end
end
