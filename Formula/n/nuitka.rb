class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/e7/1d/c301a8a38fcc98e8eb72bd0f34472f0f5e15a39e726c98f05878c68da446/Nuitka-2.8.2.tar.gz"
  sha256 "36af094e9e36ed3cdb33bc54e04bfe31b1b3a28c54b06875a411f61a2164b917"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004d851611d4f41017e6ed2487a8785afbcd8a6a52c6e6b5a7db5c08acbe72e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ebcd41e1d3fa7479b4aca873ee3d42783c5171568b5bb39b94a11096cab009e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dadbf60ee750c7a52e2162d3f78438f844aaef3f3502ed14b9f0a0f8475a704"
    sha256 cellar: :any_skip_relocation, sonoma:        "099d51b64b0e21a94322bed7b70d7f68426b4b49acd18f8c89f0b4388a9fd1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e8cb4e94e2b2c100c97f9deb21e7de4049e03970c1906b427f9450e5e727b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c85cbf2fee94d7ab70d114bbdc1b2f172ded0b0f3eb26ef80c9c91954df54de"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
