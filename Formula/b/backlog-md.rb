class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.29.5.tgz"
  sha256 "4c9f6a599034ca1df4230efc5c6025a56781a8f60a0df9d415af38a46800ce72"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a8fdacadaf0bbc3c8e1eeb29fe21f25463968d2e1e6fe38d2590a4532080e63e"
    sha256                               arm64_sequoia: "a8fdacadaf0bbc3c8e1eeb29fe21f25463968d2e1e6fe38d2590a4532080e63e"
    sha256                               arm64_sonoma:  "a8fdacadaf0bbc3c8e1eeb29fe21f25463968d2e1e6fe38d2590a4532080e63e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f209408189081667b3e40ffe7bf837595a631d6ecbe39c1aa6f9838348f23ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e611d259c832d117cace145d2eefa2dc9334f1de2c3bcef48733fae64b0896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03eab7728e54442e80555063e598cd5196e2f2a3218d3bbabde36ebd8c0a0d42"
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
