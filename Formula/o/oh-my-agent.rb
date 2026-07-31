class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.2.4.tgz"
  sha256 "e41a5bbcd59cefd4c5cbe9ddcc14841e07cc8cfb6e4085adb626ffd16fc3f1c9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca63c61b5694ebd5a0dcdbc53b45fd9dcb1205e3431c14c593db4a9f96c472a3"
    sha256 cellar: :any, arm64_sequoia: "ca63c61b5694ebd5a0dcdbc53b45fd9dcb1205e3431c14c593db4a9f96c472a3"
    sha256 cellar: :any, arm64_sonoma:  "ca63c61b5694ebd5a0dcdbc53b45fd9dcb1205e3431c14c593db4a9f96c472a3"
    sha256 cellar: :any, sonoma:        "b54af6dbdd592bcaf3a5b093714255f009acd4728cbedd501973c2da9a20493a"
    sha256 cellar: :any, arm64_linux:   "32c92fce015ba9c438aa7e1c695e27ab42742ec37e5bbd077e5dfb003ce40d5c"
    sha256 cellar: :any, x86_64_linux:  "54955ce0a799d5a8189216063b78fcd94935b13d133a9657446baf80bd753179"
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
