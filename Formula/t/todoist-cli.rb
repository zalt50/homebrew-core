class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.7.tgz"
  sha256 "f2492c52b0fda7512085aa64c9bcebce6062f56acd49de4384206363994cb7c0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d720ec7fd9bfc48f1f1276c119a8b34a7a5c27d72eafb35c8c53449ee314e37"
    sha256 cellar: :any,                 arm64_sequoia: "7d720ec7fd9bfc48f1f1276c119a8b34a7a5c27d72eafb35c8c53449ee314e37"
    sha256 cellar: :any,                 arm64_sonoma:  "7d720ec7fd9bfc48f1f1276c119a8b34a7a5c27d72eafb35c8c53449ee314e37"
    sha256 cellar: :any,                 sonoma:        "d098d013053b163da1b79b60dc0935ffcf3bf970b31d6bba0d58c47258f01ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e8f4835192a41835d5ff242ddc0c132b2a36c029f7bc56a81c2d1a12e65f06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7830ffbe67657c66f060dd0b2dac02996251de4afd1e3aa4442ccdadf90ebfef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
