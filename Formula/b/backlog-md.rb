class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.49.2.tgz"
  sha256 "98ebd4844ea8d51969b9524be911aa55061f6ac933b3fe02c2f3ae6fde18fc44"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "187b39fd58cc037cee718574c9638266f90a3b0a0817d472c98fd6596624de71"
    sha256                               arm64_sequoia: "187b39fd58cc037cee718574c9638266f90a3b0a0817d472c98fd6596624de71"
    sha256                               arm64_sonoma:  "187b39fd58cc037cee718574c9638266f90a3b0a0817d472c98fd6596624de71"
    sha256 cellar: :any_skip_relocation, sonoma:        "582794f4e76259ac5d4627bcfc64118a1db0dbe8bc632c141cfb624520c10372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05dfda8bb25a78fbc21d85186f597f372acf3440066e46ac8e86cd8c816d4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32196cf2721098eafc0c053683eca3c9a706bfa7f8c72c1ed98ee4bdb07c44f"
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
