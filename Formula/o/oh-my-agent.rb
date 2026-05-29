class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.16.0.tgz"
  sha256 "a7f28a12a48a3e10a5edc910cae141bb08680e558f190d9e76a303aea1f12447"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df83145b1c7f1c1b75a97a6fc508f28a4050ef0d85eb7cd8cd5f3130c7ac755b"
    sha256 cellar: :any,                 arm64_sequoia: "5b8839c123ee4b51e98d2e2cc413f10226e1c50418411ac33bcdbb8b5dc20855"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8839c123ee4b51e98d2e2cc413f10226e1c50418411ac33bcdbb8b5dc20855"
    sha256 cellar: :any,                 sonoma:        "449233cfd3e65f9022fa9745d04b197fcdff6cd6f2da2301fa6dfce79526d48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6558595ef11f22b30bb78b352adadfa2263a869581f0eb58362248cd6b008ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18baf2add26f8b87d45575b3b6943690e65ca7e2fba89926a5c25004fd32e474"
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
