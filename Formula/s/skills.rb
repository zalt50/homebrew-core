class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.18.tgz"
  sha256 "8fbd0e3b7dff9c9c89af95cf340f6735f38e09a3b299b150405771ff6fa26751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43c953044497512d8c03504f08d8e0f21a16747f209b1553fbd8899582682cc5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
    assert_match "No project skills found", shell_output("#{bin}/skills list")
    system bin/"skills", "init", "test-skill"
    assert_path_exists testpath/"test-skill/SKILL.md"
  end
end
