class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.32.0.tgz"
  sha256 "f8de2fddee2c313f19599fa8d9ed57cf12e211498eceba52145e39de2f371e74"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7ccea18cf2e6c2bf4cb957665507c8e3254a821ec8c74b0dcb53aac1fd0a8844"
    sha256                               arm64_sequoia: "7ccea18cf2e6c2bf4cb957665507c8e3254a821ec8c74b0dcb53aac1fd0a8844"
    sha256                               arm64_sonoma:  "7ccea18cf2e6c2bf4cb957665507c8e3254a821ec8c74b0dcb53aac1fd0a8844"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e7935cbdb4c1b8678aac9824aea722ed7134b8d49aba83a2d1fc8fda224ea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed1400b217c94f771c72efb702c1cf7e79ddbf57f920a2a9927b0db9be396833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a23e6c1e12a5da09fb8bb8287dd2d008d9e9e38091320e6339e43ae9eab2d8"
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
