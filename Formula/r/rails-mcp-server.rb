class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3a9fdb7c03ba728e200780a04c10c058e87d51f81470abfcb97075d64208c11d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4da7b2c531ffc5359df7787e39c6d0082c09bcf926dc78ff5f86e9375bca1c53"
    sha256 cellar: :any,                 arm64_sequoia: "6a119aa7dca2269d00b881f21909599440b2f1b4df4d9a2a0a423b287be0fc2f"
    sha256 cellar: :any,                 arm64_sonoma:  "81e78ace76bfd91c9e1a912d76214bfd5d0d400f0bef661a8852097a4b7ab21b"
    sha256 cellar: :any,                 sonoma:        "54b8592a3ab95d03d7811e5b468b6a70db2d06ae16b7ac15cfb7284955013e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f88feed51fdc4c3eb4f72fb01b1565430ca453cf8f7b0d545fdcba37e41896f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c171df4f13a77ef2a9f0e031e2d10a17710aa52852566dbc47778974477b700a"
  end

  depends_on "openssl@3"
  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      test: #{testpath}
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/rails-mcp-server 2>&1", json, 0)
    assert_match "Change the active Rails project to interact with a different codebase", output
  end
end
