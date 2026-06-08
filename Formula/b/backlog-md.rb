class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.45.3.tgz"
  sha256 "ff76be7ca8446b4c2e7b6a57b956a652530dc095e7d6b8858679c2bca2169480"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "be378e1ff6fe474eb8536abe48b4be9be0259303ec78122f37dc73792e6cbe82"
    sha256                               arm64_sequoia: "be378e1ff6fe474eb8536abe48b4be9be0259303ec78122f37dc73792e6cbe82"
    sha256                               arm64_sonoma:  "be378e1ff6fe474eb8536abe48b4be9be0259303ec78122f37dc73792e6cbe82"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ff3f147baf685cbafbbb072b03280910a029e78d247e2526a4db3b7ec57b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb66feb1ad53f9c47f6f8442f3858779672aafc853b9b94bcea32aa89c4dd8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d646d79fc413990e623e6bac35ceb961563f403e5d34e7be7874f10be88956f1"
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
