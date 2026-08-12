class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://cz-git.qbb.sh"
  url "https://registry.npmjs.org/czg/-/czg-1.13.2.tgz"
  sha256 "0d25639921912ba15fa834e083b7b3a8d2b795134b6f44ece992a74ea8bdd834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d74856f5a0e89a8cde2043dec2fda8b204ec107e38333edc10253531b800b3b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
