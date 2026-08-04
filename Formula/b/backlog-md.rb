class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.49.2.tgz"
  sha256 "98ebd4844ea8d51969b9524be911aa55061f6ac933b3fe02c2f3ae6fde18fc44"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dd5a8da767eb381b255ceea6e220b2e773043b5ff529f38d9265059557bce2e7"
    sha256                               arm64_sequoia: "dd5a8da767eb381b255ceea6e220b2e773043b5ff529f38d9265059557bce2e7"
    sha256                               arm64_sonoma:  "dd5a8da767eb381b255ceea6e220b2e773043b5ff529f38d9265059557bce2e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3194f1d70cf032dbc5ffad831154eb9e8cc83ef52f5f482e77926fd04f0cf391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c785ec301fb6898f0940c0cac2fd5c85299c539750cf0ff00b5b2e9ec16fd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c975096e8daacd01e24e8e868d3e66e1677b2babfd47fff3e64bf98db7b5226d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
