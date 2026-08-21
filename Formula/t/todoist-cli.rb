class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.2.3.tgz"
  sha256 "b167c55b3ce715fb1b37b3caf3f34d7145af18631c37ab35d84a180e7c17f1a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3b8ada8fa718a4a157da04735d1574d28e3cbf835d1e81444f0769a7b0bba09"
    sha256 cellar: :any,                 arm64_sequoia: "f3b8ada8fa718a4a157da04735d1574d28e3cbf835d1e81444f0769a7b0bba09"
    sha256 cellar: :any,                 arm64_sonoma:  "f3b8ada8fa718a4a157da04735d1574d28e3cbf835d1e81444f0769a7b0bba09"
    sha256 cellar: :any,                 sonoma:        "ff479bd001307db3969dd61304b6dbbb3a92c40da24046559d5ee452370b3fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c3cadbb8c27bb58647e83be322633a40d7fae8529a4d59d6e28d7e973c3188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada7c2b97ef9b3499224fb7604ad6ee51a7a82bcd02aa643c393ee3c356a268a"
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
