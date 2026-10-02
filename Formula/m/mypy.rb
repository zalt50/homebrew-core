class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/34/4e/64300736cf0a0373a27b94a91b664ee7382e36f77b0621bae6381da3e180/mypy-2.4.0.tar.gz"
  sha256 "77bdaebd452f43fcfc4cc3ba94352a3ea537cd01e3f2d0879f48673d2ec00d6e"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "efac5d02d4dfc817f401550e360de1daecf244c4bf94baff0623e62a4ceac42f"
    sha256 cellar: :any, arm64_tahoe:       "59f0c8fd330bf6af943895992125c637f83924bfa3d46d6549914914d37ae70a"
    sha256 cellar: :any, arm64_sequoia:     "1e75f3e3e3d147cdb8710f9551e200abbd67fe840703f2466eaa068a8cdf7ec2"
    sha256 cellar: :any, arm64_sonoma:      "6996e04b925fbbf2bbf42fa6e2a3d4dd9171dfa11d9bf16d2a3b51c4ad642a05"
    sha256 cellar: :any, sonoma:            "e8f4d0b98197f196d318e240f79392b07e730d0f13558abf83e889f7fc3ffd11"
    sha256 cellar: :any, arm64_linux:       "91cd8ab965f162b06d6ae545408325751a4e3edaf3abf984cb90e10bbbc0f2fd"
    sha256 cellar: :any, x86_64_linux:      "7266220087d1ccff94d178dd1ca46993352ccb9577289cc30fa0d7f17852788f"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.14"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/54/1e/4f6082cdd6e5a29093513e9a3eabc5ed1c5331a9a84386b2fece80a00a48/ast_serialize-0.11.2.tar.gz"
    sha256 "976a5bd75845d22f4b52905ddf53ab669ef1b14dba7735f5512841a2ef2b5450"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/04/f5/9dc696772d241814bacac7880bac32f2930b5a6ebc1f85317b83161a011c/librt-0.16.0.tar.gz"
    sha256 "ac38d6d8d66bf3d744148dbbc0b8e193e195a51e364ed55e224631f5721891fc"
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
