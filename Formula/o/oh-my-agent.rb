class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.41.2.tgz"
  sha256 "cac0a3bd87a1b0e6729d7ae8440d2495939f7aea4721b1b038659e3af1e6621a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cab60807ef8cbcb3a0b6440595e3c39316c47cc9877052fc8f59f4839f82d71f"
    sha256 cellar: :any, arm64_sequoia: "57459cd20ff6deef45bd784680f4087387811eb0ef3a39aae8d28eb198e9e31f"
    sha256 cellar: :any, arm64_sonoma:  "57459cd20ff6deef45bd784680f4087387811eb0ef3a39aae8d28eb198e9e31f"
    sha256 cellar: :any, sonoma:        "a18beed284cab93791cc66a78ced513b1d1c06a28c5602757697c2db716e4bea"
    sha256 cellar: :any, arm64_linux:   "4233fba81fdbeec2decc87f1871fc524f3c2dbc9f1739aa7809f1859dd920fe9"
    sha256 cellar: :any, x86_64_linux:  "20c99fe6cc20b49c1f54a0771bccc9559b0b300678f74efe05bbe3e2702f0b86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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
