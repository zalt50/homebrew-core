class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.20.2.tgz"
  sha256 "73ac373dfdb50dd2a8aed033d65adac762a469cad0e3e38c866760f755149f5b"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "663641be4525f1a479eb189be639481f95c2cfa5fe05cfea0a79930b8ba138bc"
    sha256 cellar: :any,                 arm64_sequoia: "fd2994d57c2b87853f96aab018d69a665e2cf251b38b0aa263b2e42b2a89a56b"
    sha256 cellar: :any,                 arm64_sonoma:  "fd2994d57c2b87853f96aab018d69a665e2cf251b38b0aa263b2e42b2a89a56b"
    sha256 cellar: :any,                 sonoma:        "b9809fed5fb3cda6e9ea29fae23fbbc894a44e802bb3d185b80b58956443e08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1230f0147dead14172b75ada601bd4e28af514b25fa1166d0e7fda2ccb51936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d135fcab46f27b307cd8251d19fd77aeca504245cc2c4d1915beb9aab346fe9"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                         "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_vendor_dir
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    platform_dir = ripgrep_vendor_dir/ripgrep_platform
    platform_dir.mkpath
    ln_s Formula["ripgrep"].opt_bin/"rg", platform_dir/"rg"
    bin.install_symlink libexec/"bin/claude-agent-acp"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thr|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
    ensure
      stdin.close unless stdin.closed?
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
