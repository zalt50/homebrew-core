class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.9.0.tgz"
  sha256 "2d119d65984cab697a327c1e587fb75c6a2c224f2e08b284dcc74d9526c5b4b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71baae098c78d2b1492b017b311f76d14e6d69b02ea27b72c873e7dad27409f5"
    sha256 cellar: :any,                 arm64_sequoia: "e2161b6dbf1943a59cafc2b23607af06bb4e2f3c4bb01bee55db6ae2a57f069f"
    sha256 cellar: :any,                 arm64_sonoma:  "e2161b6dbf1943a59cafc2b23607af06bb4e2f3c4bb01bee55db6ae2a57f069f"
    sha256 cellar: :any,                 sonoma:        "6b2ea67b362d20f62e05ccbfb44da4dc706858546bb7845384111ffdc6ad9902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de77728484159df41f93ddb53623a583a3afd1c353504b7d9c0e3791c2b6778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c062e0ec1c3dca893a5dd439b14b2f09d60d8053bf5b735234d72898e445d388"
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
