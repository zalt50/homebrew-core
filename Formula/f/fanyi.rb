class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-11.0.0.tgz"
  sha256 "7893ae87298c3731ea4a846e0c766db698c709d9b13d20f16bb8177e8d1c7100"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "351b581b6235da82293d624349d95b50a9ce217ad4ac07d5e2dad3493e541c2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
    assert_match version.to_s, shell_output("#{bin}/fanyi --version")
  end
end
