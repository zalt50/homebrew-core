class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/fe/ed/3fe00b8a3f8a74a993e1e08931d674cde7bd718c1af44ef415ff1f6b000b/pyspelling-2.12.1.tar.gz"
  sha256 "9108981dc174d6400a7ed4917cf4af91daf3eb83578d4570c0726b92c2a32e7a"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b83f670c1567255ad8077ae70987a89ddfde7583ab0ccbc1d4147bc502715797"
    sha256 cellar: :any,                 arm64_sequoia: "2c23257399b2741659bb05d4ac7531407b922267dc4137ee13f8b14f28c75c64"
    sha256 cellar: :any,                 arm64_sonoma:  "b21e9048e501d3487e9a95b98d0ecb0f5116e392fe7af84ef9083e84e8ff828a"
    sha256 cellar: :any,                 sonoma:        "76cdc40c40302803ad264b8f4d238d2a611b25e69788765d0fb22e6b839576e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b939f1d658130b42b15a064b1310bb36f6e45abb8d1ad9abfbf6b7c5bd7d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e138038bbdda3924b4b0a8d4716e0764a06e40aa61b6aea44b74f7870ef172b3"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d0/f5/4473ad9b48cd0420a2d762a3750fa0e078e23e060b1af72662e5987e5530/bracex-3.0.tar.gz"
    sha256 "b73f718d6bd98d8419e45df02426c86e9967c179949f779340d6c3a8c83b9111"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/11/15/dc61746d8c0852f6d711ad09c774b63cf7c8211aa49e30871ac3d342b7e2/wcmatch-10.2.1.tar.gz"
    sha256 "ecac70a5c70e62ba854b78318d3a1408e8651f8f1c96e5837743b71aa6a4fb92"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    # Workaround for https://github.com/html5lib/html5lib-python/issues/593
    odie "Check if setuptools workaround can be removed!" if resource("html5lib").version > "1.1.0"
    (buildpath/"build-constraints.txt").write "setuptools<82\n"
    ENV["PIP_BUILD_CONSTRAINT"] = buildpath/"build-constraints.txt"

    virtualenv_install_with_resources
  end

  test do
    (testpath / "text.txt").write("Homebrew is my favourite package manager!")
    (testpath / "en-custom.txt").write("homebrew")
    (testpath / ".pyspelling.yml").write <<~YAML
      spellchecker: aspell
      matrix:
      - name: Python Source
        aspell:
          lang: en
          d: en_US
        dictionary:
          wordlists:
          - #{testpath}/en-custom.txt
        sources:
        - #{testpath}/text.txt
    YAML

    output = shell_output(bin/"pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> #{testpath}/text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end
