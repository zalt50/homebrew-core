class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.14.tgz"
  sha256 "47bb3aa6ec2f8872c3a3f7c2d89ad47e3ead804b87e007431f6ad64fb896cd51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "636d37ca399490b1add385c74ab13f6060839440b9b462f5ece315207c72a8a0"
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
