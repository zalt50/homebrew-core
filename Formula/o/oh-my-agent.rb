class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.0.1.tgz"
  sha256 "395aa952d0ded4905cd37d4e5b3e5b879943f77d6909c9f8080b111d55a1ff6b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7fc8b6316b245f482d83d33f031412c0c8e4b9c3b7abe5e5e9b622f682ced6d"
    sha256 cellar: :any, arm64_sequoia: "d7fc8b6316b245f482d83d33f031412c0c8e4b9c3b7abe5e5e9b622f682ced6d"
    sha256 cellar: :any, arm64_sonoma:  "d7fc8b6316b245f482d83d33f031412c0c8e4b9c3b7abe5e5e9b622f682ced6d"
    sha256 cellar: :any, sonoma:        "91cfbeb40b2bef2da209e3a8d936d741fde045c132fdcd3049c9292c0ac8c1c5"
    sha256 cellar: :any, arm64_linux:   "e664e43264bd18da8fd0fb360db45c4cd9ab74588b15895d00b71916a25fc344"
    sha256 cellar: :any, x86_64_linux:  "aa3beb2039c95b6c33493587408e21764d3c8d0c4fcb6817c5412a62a03dfcf1"
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
