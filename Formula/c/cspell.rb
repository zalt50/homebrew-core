class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.3.1.tgz"
  sha256 "9be8be66f0e39facc852e3a7fbd423b3e494842c830d43de5b4271f27b9ca770"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5979fe98a34117f43dfc6f516f071e64e27df70a26c8fd3be1035b922d86c94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
