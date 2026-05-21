class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.4.0.tgz"
  sha256 "3359f83991e9a17e93cc9a2b8977ef6000025af3e697758e330654075d88e89b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "994aa0cc336b1d5dd929db0e342d329e68ddf6040025c65a8fdad8e95fad54f9"
    sha256 cellar: :any,                 arm64_sequoia: "4bf75e0c790fb6abb1723ccf190cf9dce765790929274b510bf0b1d0bdb0abf0"
    sha256 cellar: :any,                 arm64_sonoma:  "4bf75e0c790fb6abb1723ccf190cf9dce765790929274b510bf0b1d0bdb0abf0"
    sha256 cellar: :any,                 sonoma:        "1fac75902f10c2d049f370cf083ddfe9e7d00cb814592e91d9c62d6d5ffd2567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3713318d801dc933543164b1f32e00e9e985c74d7f99de024a9e513befb445c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82ee999cd07e07fac46be353c35494e55bc1a18276f19ff7760866e58a737976"
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
