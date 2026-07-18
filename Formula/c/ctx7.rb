class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.5.tgz"
  sha256 "5982a3845936b49ed7f32a21f97efad06ae22a85fc0be71a7c8b8fa503649c18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e13592bb2c6c27f2f1f47dadfc14dc238a7b592994e4a6f59f9a15507505433"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
