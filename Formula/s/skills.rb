class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.5.16.tgz"
  sha256 "f7f0177345ed74c8a28990fde2c05a4e4967919fd264cc73bde5def9003ec2e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a351c21572ee6b45761595d0952c4afaf6b19e58c6a80bc921ae97cde281fc5e"
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
