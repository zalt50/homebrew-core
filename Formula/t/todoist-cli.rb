class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.67.0.tgz"
  sha256 "01af96e12d7c81e141b759957f2aa12193ed7f361267d06234cfefe1a0cdebca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9e743129b30e5c3e8cc1b6e0940bf36ff2c8852cc874e7f776a7527e3dfa033"
    sha256 cellar: :any,                 arm64_sequoia: "a155243ac5b77809b85e6c966f3bf384c1521b7bd655a95107c1307d262e5a46"
    sha256 cellar: :any,                 arm64_sonoma:  "a155243ac5b77809b85e6c966f3bf384c1521b7bd655a95107c1307d262e5a46"
    sha256 cellar: :any,                 sonoma:        "3e539a59270a206c717c7818c2a0a0972a285c77456971247e2f895f7dc24eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3041e0b74330087b4c26779ecea267aaa418db52b782289a5ebe34d0e6f39d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb87ba6fd633a63d9a463f1e1575f77ef23bf17b8c0985af884d5b17acf1208"
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
