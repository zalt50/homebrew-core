class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.0.0.tgz"
  sha256 "10583f3dd01cfe4e050b2581e50902adae33fe6bec32074182cb47287799d9d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b7543045eb6caca1e1c68781d601b5d000d405536380a81d01dd68f9edeafc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd04831b2d28c4ac7e7d4e7f13b4c4ed27b2592644d5c862e599b411178b4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613a7aba38d3b9a1c4e5c68535c6f25ecc9ff6b9078f964a1995d8cb79ddb5d1"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown/archive/refs/tags/v1.1.5.tar.gz"
    sha256 "2042204fda63956408dc102dd5cf5577368077ed70f9bce68474ed983c779879"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "349be987e7582e6aa26763b2de96c4cbbd0d3cfba2417d9733524589fdbc275f"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    resource("rolldown").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--package", "rolldown_binding"
      dylib = Pathname.pwd/"target/release/librolldown_binding.dylib"
      node_modules.glob("@rolldown/binding-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
