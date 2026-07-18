class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.19.2.tgz"
  sha256 "5edaec398296df09cf5e2e7743e66c99a066f222f410c40f051c869dec4674b2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49a3cc0b785d95b0ae7ce9af93aed2df0740ebdbf244a2d8067be820b6c6ce32"
    sha256 cellar: :any, arm64_sequoia: "49a3cc0b785d95b0ae7ce9af93aed2df0740ebdbf244a2d8067be820b6c6ce32"
    sha256 cellar: :any, arm64_sonoma:  "49a3cc0b785d95b0ae7ce9af93aed2df0740ebdbf244a2d8067be820b6c6ce32"
    sha256 cellar: :any, sonoma:        "6bb184671e2b4fe8d9bc2b537523d8220ffff510f283b1376b534cd9960d0de9"
    sha256 cellar: :any, arm64_linux:   "110cd484ce8d635ceaa8a6bd78edb124021a567c711710f51d542729df7437b1"
    sha256 cellar: :any, x86_64_linux:  "7aed04b1b8b98027c8251d7528f4ba1a6ac5731eabec7d957cd105ca562b4880"
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
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
