class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.20.1.tgz"
  sha256 "6468b59590663f6304fe3e145b20a98b3c309087d5ec944787efc42bb623056c"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17a316942a6c25519b63ffe2dc6b8d61a20b0f1441c8e3155f2c87dde0b4c499"
    sha256 cellar: :any,                 arm64_sequoia: "3c32db69037794edc3148cfe639e0575a01446a4c5066a9cc7f9d81d166dc72f"
    sha256 cellar: :any,                 arm64_sonoma:  "3c32db69037794edc3148cfe639e0575a01446a4c5066a9cc7f9d81d166dc72f"
    sha256 cellar: :any,                 sonoma:        "5c972364292dd86dcf88fb334d6141994d7e9ffb3eabf70d65aa40b8ebe15e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c76d7ca17b364742c9594050048bbd0f2a84672007cb64dd541e95c6ae235c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6661f414c5e3169dbe1fc43562db7c37f8b98dc819fcc6b0a4f147a72718c0"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_path = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                   "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_path
    (bin/"claude-agent-acp").write_env_script libexec/"bin/claude-agent-acp",
                                              USE_BUILTIN_RIPGREP: "1"
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
