class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.3.tgz"
  sha256 "258882d1ca7a3ada63892a99c2ac21f84e44fc5da6797f51fefa6c48921325b7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b250f9c37e5944eafed6ab27e2777e1dbae85af8ab3bcd419aa70f0859fcf4c5"
    sha256 cellar: :any, arm64_sequoia: "436c2c744d535006d1f87a92c358cb4fd0bb4d1a7b9d5214b78d59aec98b3c36"
    sha256 cellar: :any, arm64_sonoma:  "436c2c744d535006d1f87a92c358cb4fd0bb4d1a7b9d5214b78d59aec98b3c36"
    sha256 cellar: :any, sonoma:        "2b30d72f01d2ed56e21f333799015eeeee586007d61907a0f0c777bfec4eb841"
    sha256 cellar: :any, arm64_linux:   "562fb8ab010e67adb693cf96f3201b5f7c2117598f9bf5857253fd3f9357bb7e"
    sha256 cellar: :any, x86_64_linux:  "3c3d5f03415694e4d39995387fcd12d48db49975aadd52f7fc68604490399820"
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
