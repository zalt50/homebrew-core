class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.7.0.tgz"
  sha256 "34ae265e48171ff43bbd6fa066ae9e5f879cf88cdf15595d0c24c432d21a163c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93eb93b1d3bc50d3f65f38696b39b70e102c4032257a81e693313885a084ab12"
    sha256 cellar: :any,                 arm64_sequoia: "3408830f171c8e5b744008595c28a396a16f05d276ddea8870d0c8d3abdfaa6c"
    sha256 cellar: :any,                 arm64_sonoma:  "3408830f171c8e5b744008595c28a396a16f05d276ddea8870d0c8d3abdfaa6c"
    sha256 cellar: :any,                 sonoma:        "074165335fa6b02817c1359eb1dac49b5ef0baff156fba0844ebec4334b5cc93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bbdeeb1a72e20e04c5a7c092a795eebcd70e60a2112c28602b57b3095170bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20c8b0041266610bf9bbc4858e580462e2bb3ebabea3d718e39b52879a4cbf0"
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
