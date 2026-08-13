class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.0.0.tgz"
  sha256 "7ad1d578338afd303c8bffb2dce084274a26bb81a1e9005d1fb6cfa00f4c8f16"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e09f5f8373fa1db89f97dd68a2f0f0c3673194ee9fb4f5ff32b29d0915b42500"
    sha256 cellar: :any, arm64_sequoia: "95f6b0814a05d842bf26ef50e069e2602b2d6bb407d0342f76c44f8552a802a2"
    sha256 cellar: :any, arm64_sonoma:  "19f2318f486e51d67e9e6b6e5f1675ca5dda5b7096289b82f2e74956f3845eb7"
    sha256 cellar: :any, sonoma:        "4d2992bf70fa604255c5eea01d7d7d599adb6a34e3a5eccde0881be19164c480"
    sha256 cellar: :any, arm64_linux:   "f840071dd92d670c86b1e77163025a504dd727dac607609bf963aff52d68e61f"
    sha256 cellar: :any, x86_64_linux:  "c415f8063f1caf6b450153f56194572bb99db4a53e1ddcc2ee2cac83068a148c"
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

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

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
