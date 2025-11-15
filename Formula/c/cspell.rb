class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.3.2.tgz"
  sha256 "c0d9d9e91a7cd4e8636b2e4a58b7f55f48743a7d530a7e257b7926facde6dddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a37790bf142d7d3bdd99003655345bc66d521967f8d10d10f90bf8970e1ac074"
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
