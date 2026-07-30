class DockerComposeLangserver < Formula
  desc "Language service for Docker Compose documents"
  homepage "https://github.com/microsoft/vscode-containers"
  url "https://registry.npmjs.org/@microsoft/compose-language-service/-/compose-language-service-1.0.0.tgz"
  sha256 "a05c72415a94db9ebcbf51f99eca082f93d99e1e78ae4bd3d187eda6832c9d5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a017c7c6e4396b8f8fdad2e301cd99df373af2dea6a6eb41f3b05213ca50ac93"
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

    Open3.popen3(bin/"docker-compose-langserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
