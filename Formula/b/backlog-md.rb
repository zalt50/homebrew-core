class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.18.3.tgz"
  sha256 "0b5178873f823ae8300fb495e5a82f62da0b58dc841aa3fe61f4980a0656c61a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f82c70088ae7eac93037bd9aa134fb14568e364e183b7d2048241bfdf3d78848"
    sha256                               arm64_sequoia: "f82c70088ae7eac93037bd9aa134fb14568e364e183b7d2048241bfdf3d78848"
    sha256                               arm64_sonoma:  "f82c70088ae7eac93037bd9aa134fb14568e364e183b7d2048241bfdf3d78848"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a66767dd6098ab7618e0ed3ac70843b226c7ae5daff1fcff8a8485532805aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "094429fdbf0b89642940fa6403b4103e1600f4541f7361241ca8c86411d80bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4409ae89183513eb4da80c47a54fe866f15cb6b272082199da1c5a9da099a5e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
