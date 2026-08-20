class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/bc/1b/2824215bc282e52bd6ee4b699e931fa7d64ea30fd8831529fdd0920f5969/translate_toolkit-3.19.18.tar.gz"
  sha256 "ef1496e9e0d6d5f9647cd7365f91be161c3197104704e81f3a0017ccc7f4f5b9"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d772e602ee1d2d2df7e369fcc63a05056836bd60a3c2dce06021ff1542df83b3"
    sha256 cellar: :any, arm64_sequoia: "e877f784955b1924d6eb077fc79e26963ba659ae91acb2955b015d34b73a6e3e"
    sha256 cellar: :any, arm64_sonoma:  "a9e099b02f0675e94ec9d59bd4e061569c0659eaf93fae8671dc5f92a6b246d0"
    sha256 cellar: :any, sonoma:        "9743d7f8af960bb0ce807e0312328f899dd3ca7ae9d0a3a410cca3c93ee53293"
    sha256 cellar: :any, arm64_linux:   "f576442f40d65e552de2403ffb1c02826c779e4f74dfc717862bb5ba3ce5c274"
    sha256 cellar: :any, x86_64_linux:  "ad98e7303e6cc8b03110d39331f3aa06c96ebbe3ac333bd5ab77ccc859289e32"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/0b/02/e5804acc54945ecf29a280f5f173db61c019166bfe3adeee386f4c135f17/unicode_segmentation_rs-0.3.3.tar.gz"
    sha256 "d6625b2d3435ca814c9dd6590d39ae58ebeb8a4891eecb81446ad8b3e917f39b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
