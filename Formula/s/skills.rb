class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.6.0.tgz"
  sha256 "d8601291f5b5535bc411381d4e297690f10c0de48e01e8c7d3a78a66ef3e30e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06a6941b9d2e14ff94590f735f0115ca1e7203c4e52d5ada8536e23c1bad47dd"
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
