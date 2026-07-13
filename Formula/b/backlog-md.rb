class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.48.0.tgz"
  sha256 "48ffb8cc6b3a9bb9acd2fe162a5496115bf50742d687f5747df41e448f769ad1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "047c8b7b0dc8de925aa67028affd190893c83338b4e18981fe6066fdf4120b45"
    sha256                               arm64_sequoia: "047c8b7b0dc8de925aa67028affd190893c83338b4e18981fe6066fdf4120b45"
    sha256                               arm64_sonoma:  "047c8b7b0dc8de925aa67028affd190893c83338b4e18981fe6066fdf4120b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ae6700fd36ecfaa534836951e70d0bcf786c9459517cf01afbcfd9605589b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe8157f97306a88d4bde452d646ab7b7246a5d2e744869fc810feb53789129f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7368c8e8e3ec4aa174c1c4055da58ef0a2d0ca96cae1d04b3e12bba4f98aab7f"
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
