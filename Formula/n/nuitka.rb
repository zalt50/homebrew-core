class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/3f/d8/bdb7febea4b4fe5d3d6fe2610f946771f03e792e05a5e8ec00b62c00b265/nuitka-4.1.3.tar.gz"
  sha256 "838ff8899dc2f0b652d4fcf6c5d7466cb7ad5abcb005668ac622d1e40f4d8a8d"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f1bc18263931735a823916b99a0e0671d9990aadb6b712f05b5499402034f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f4589f94bbabf12985a66e08510e3712af34f21db3c4943fabf53a2b143989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d7c424e1ec756bab0421b786bb964bc94349a1cbd57581c1278f07086f3506"
    sha256 cellar: :any_skip_relocation, sonoma:        "9476737584dd42a9a9318400e1233321dd02c42af02852dc79b530d0852a1988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f9a8a4c27cecdbb26e9bff0bd0b67a8693a667e51bef94a9802c01cbc37f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6c9f88841ae624dbaa209aefdc2deb79ae39d4847a09abd935425a294864b8c"
  end

  depends_on "ccache"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("doc/*.1")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    PYTHON
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
