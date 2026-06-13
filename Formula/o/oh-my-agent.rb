class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.0.2.tgz"
  sha256 "d551b1938843bc8bb3902d358871ef22bbc9d2b3e657c960aa9650308fea037b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c290ae043741e6183de604c0d572c3877abab5832abdc0408fef28f6693dfa6c"
    sha256 cellar: :any, arm64_sequoia: "ad757c9c664f2a5aa6ee95fcb41f0940014139ac6c34c17ed5c60aab4269117e"
    sha256 cellar: :any, arm64_sonoma:  "ad757c9c664f2a5aa6ee95fcb41f0940014139ac6c34c17ed5c60aab4269117e"
    sha256 cellar: :any, sonoma:        "538b7d789c5f4717cc0021726aa942d7ef933e0de1555a9b3ce630a82d3dd548"
    sha256 cellar: :any, arm64_linux:   "38d7550b5c15f34d9d1e62c4d82e1a71bb34379991b598c9a1a77b13592b2624"
    sha256 cellar: :any, x86_64_linux:  "2ee8d20a1e451398957fbf8472aa7c676ce41d56f5fa8ca4b2028cd14613a8d1"
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
