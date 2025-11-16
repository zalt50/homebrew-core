class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.20.1.tgz"
  sha256 "2802031d9e7d53e4c2c9f2dc175c0ce805969a05c2bf7d40e211cc6783de86da"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "098567bbb311478ab1ab338e7a58976b37f60d057fb17de613fda1a629333074"
    sha256                               arm64_sequoia: "098567bbb311478ab1ab338e7a58976b37f60d057fb17de613fda1a629333074"
    sha256                               arm64_sonoma:  "098567bbb311478ab1ab338e7a58976b37f60d057fb17de613fda1a629333074"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ad5ff9acc322b95dbaf3a415de2e5dc4247e72dbe6c0b775b6793e278276a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "003ddffef0086e54a779c38594228978cf2b4d26b6d0baae72520e53bbf4e1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c2a15b66e3afdf7348cf8a84749d3fc51b86cf58e7e45e29e996495eeff274"
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
