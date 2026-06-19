class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.12.tgz"
  sha256 "d5010fd9a942c79b38cad60f340437a07e1d19ad2e455bc593af10949ba8e534"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24ce348432dea5e65fc999d958b5a6140d92263eece8386af5ca153b40a95429"
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
