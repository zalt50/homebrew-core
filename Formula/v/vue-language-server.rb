class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.2.1.tgz"
  sha256 "e6d02597a6ff1d7a89671aec12fa504c895ef30e67cddc7fc758bfb9bdcb7ff6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f05e8f3aaf034610ac62348e37174c7d5876e5b378941f62c2ae6aaad7c938c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
