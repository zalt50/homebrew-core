class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "aef71b34cb41b4dbcd93d97f8e750d4f2fd15e74fb03c363dbceba22d6d5fa52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4cda119c2ea44dbf1c0365fb1d6fb0d35a5a6fe7a1d52a31011cd0a7a14bb89"
    sha256 cellar: :any,                 arm64_sequoia: "d1b57b2fb3243c8bd860ef19b49837e2d01e1677149af66576bbeee9b8cbec4d"
    sha256 cellar: :any,                 arm64_sonoma:  "bf572dbf1b0318f7ee7ea9ee712c97dfba692573354b1a49d339808008b115f6"
    sha256 cellar: :any,                 sonoma:        "8fe66977794a4a37c3ee3d779c7cd47ecc44b9bf91b958767237b4688124b608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108f655cefb5d85a0b3830f69c088bf0aa4cabbc6a0f5b256c7a773d2d6a8a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d0a30d1265ac1847706486318c851b9191d1a6f71c9a3e95c51a29f52ff623"
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
      projects:
        - name: test
          path: #{testpath}
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
