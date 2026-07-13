class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/b6/6b/80101e02ebacaf9232ecf32bf6a788d36b27d820ee02434746252569ef98/cython-3.2.8.tar.gz"
  sha256 "f4f23a56b25221a06f91817fe8f3114ab8b48a4fac73187dbb64bc2c4a87961f"
  license "Apache-2.0"
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be70819a19262dac44cf976ab33523a774cf17cd87835ebb79fd7aa725ec625e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6441816b31243f0a22b5bdb9205ab38dc26d108cbf2450c22ab470ec781e5967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "643f1cfb0695386195931e8203d7585400083cc8a954c83d3b7b06113e45e450"
    sha256 cellar: :any_skip_relocation, sonoma:        "955748e5cac120bf4a5390b3d6c2b1f7f3f9402d2cf39eb7af397f5252463f36"
    sha256 cellar: :any,                 arm64_linux:   "80f95bf2ca4a8fe962ccd937ff248987f4e70f413e79d6c4f7173e7011399796"
    sha256 cellar: :any,                 x86_64_linux:  "da644e004b46422958b2fcc2fbcce737d0f6c3193895e73ebe3a3ed565615d65"
  end

  depends_on "python@3.14"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"example.pyx").write "print '#{phrase}'"

    system bin/"cythonize", "--inplace", "example.pyx"
    assert_match phrase, shell_output("#{libexec}/bin/python -c 'import example'")
  end
end
