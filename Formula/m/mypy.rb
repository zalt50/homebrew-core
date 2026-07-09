class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/e9/7e/be536678c6ae49ef058aba4b483d8c7bc104f471479016066f345bc1f5f8/mypy-2.2.0.tar.gz"
  sha256 "2cdd99d48590dce6f6b7f1961eda75386364398fcdaad86923bc0f0231bf9baf"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b4e27bda5c117f5786d62f87042cb4cc09fa157c8ca1ba81bf671a4ee2fda6c"
    sha256 cellar: :any,                 arm64_sequoia: "8b60529e79c0d2bf761bd24eed0b3ecddc0042785acdfe8c03ac0e87c2ed27d8"
    sha256 cellar: :any,                 arm64_sonoma:  "11fb499db8ef1cfcf046719e0228513518158436f73e62fd666c9e646b3f0fdd"
    sha256 cellar: :any,                 sonoma:        "da220ecc8469cf6e8df4c0bb0485831831d3e9ce17e51667700bc037641c10a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369b00cf01a17f271f59ff28cf14ffed9232477d8e19e52f1ac0dc8d3b5e67be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ac61924167067c66692337a323729b0a275e63e01353a8f9a791a43e453c07"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.14"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/58/ad/0d70a3a2d6e01968d985415259e8ec7ad3f777903f9b1c1f3c8c44642c60/ast_serialize-0.6.0.tar.gz"
    sha256 "aadd3ffcf4858c9726bf3515f7b199c7eadbe504f96028e4a87172c0da65a8fe"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/c6/e0/dbd0f2a68a1c1a1991eb7921ff6014465d56608cdc9a9fb468a616210a37/librt-0.12.0.tar.gz"
    sha256 "cb26faedbd09c6130e9c1b64d8000efec5076ffd18d606c6cd1cf02730e6d8b0"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
