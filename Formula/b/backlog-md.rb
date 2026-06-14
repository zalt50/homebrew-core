class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.46.1.tgz"
  sha256 "149e0421fbd29bf5d35c5cc1d10640d57c7e8c5cca69172a4a47e46275321724"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fb0a59cb91082e8e0bdcc8100ecc9cbf213111cb20260ef94a52fc7b6ee7a712"
    sha256                               arm64_sequoia: "fb0a59cb91082e8e0bdcc8100ecc9cbf213111cb20260ef94a52fc7b6ee7a712"
    sha256                               arm64_sonoma:  "fb0a59cb91082e8e0bdcc8100ecc9cbf213111cb20260ef94a52fc7b6ee7a712"
    sha256 cellar: :any_skip_relocation, sonoma:        "bac4398dd0cae141463813c48a43a6da7deef5c6fee188d28d1448b832eab2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d66e300732d54248df30ab73c3daafd149067c0523a3f4d92a948f5e1757920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d35abcb2d84d08030464497c40924968357bb4cf7f5a1675e9399bb4a20618"
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
