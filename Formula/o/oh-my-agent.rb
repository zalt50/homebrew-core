class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.23.1.tgz"
  sha256 "83c71bf5adf10560371a9ee129895fc7a81670c8864e41c9b1b719d8da8ac20c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9c19d6a7fa36d4a73973a19bff36ab093bcaa254e08809cdeb5c30621a62b17"
    sha256 cellar: :any,                 arm64_sequoia: "85d255781233ac5499007941b6370fedf490604c10ce21591a64a0df30194d2e"
    sha256 cellar: :any,                 arm64_sonoma:  "85d255781233ac5499007941b6370fedf490604c10ce21591a64a0df30194d2e"
    sha256 cellar: :any,                 sonoma:        "231dacb2d4e5a5778880c8162c4c75f062d1f101afc8cc793e71a5e71f530d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a446ddaa338eff38c019d3afba724f8d6a303a3348836168cea757da2976c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7291ce9b732e7becc8d1388a22f0f1be2e1a641e3e71b0da22e6de99ff5c594"
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
