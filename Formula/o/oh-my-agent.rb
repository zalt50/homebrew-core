class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.13.1.tgz"
  sha256 "f6f6293d6e40479cd7e71c254e932ae369b18e164e6904360ee042798a6b15c1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc3f7b577cc58a1ce1c67dd23ed2b498d1e0e3576a0276bfb96e321e6df9c957"
    sha256 cellar: :any, arm64_sequoia: "024caaa5f5e8e0485e4b37e136c9224c8e3ede654f93c3d741e7b48189627ec5"
    sha256 cellar: :any, arm64_sonoma:  "024caaa5f5e8e0485e4b37e136c9224c8e3ede654f93c3d741e7b48189627ec5"
    sha256 cellar: :any, sonoma:        "3730fb808da8a1682a5bf2853ad35df0c9c69af116bb64b3d3d5e19c0fc321db"
    sha256 cellar: :any, arm64_linux:   "3dbc80b798fccc45a4e07a085eeb96bc3446ed42d07848bf038fe3006556c2aa"
    sha256 cellar: :any, x86_64_linux:  "b4277e0e809c4535b2de9ce73e42ac6933a86a7b31a4d3bacea81bbaf8a653fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
