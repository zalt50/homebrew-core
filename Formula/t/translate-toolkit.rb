class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/82/86/4135086b9c268a2ba0bc2f1d40bb5723361441f02cb9dcff262b44817e43/translate_toolkit-3.19.16.tar.gz"
  sha256 "93182ec4e922e2f0e51e9a788d0d164faf4c8d10f1e47fa98c22226bd92b529e"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b4ae8c28dfa2180a4e6a5cb30c1610fb045bd53905667e66500f3ce9cc40f4c"
    sha256 cellar: :any, arm64_sequoia: "bcc3a238e68a7c6e9695bb56ef4866b278180836aeeb31e7a76ee720048c0cfc"
    sha256 cellar: :any, arm64_sonoma:  "2baba8bbb3a7f30f418bf11e2e4c714eb508dcc0a39a4b3f4637a7fefd3ff6a6"
    sha256 cellar: :any, sonoma:        "65ce23599a26606bfd07571237f577abca4a52e5dce618394088074acc9cccd4"
    sha256 cellar: :any, arm64_linux:   "0e4e12404c5ccfe48b4f67f4b50af4096219d277291b071bd07951f171781adf"
    sha256 cellar: :any, x86_64_linux:  "0c761cffbe28524c7bcf03989e37c80ff71f259cc519f70c57d299bb9d49dfad"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/27/23/2b8888406ad5d178edbdb6efcc55740b7c307077800a705632771d34031a/unicode_segmentation_rs-0.3.1.tar.gz"
    sha256 "f7e852f8bf3dfa9073aec148d13d239fa2597b804a3e6ff51050beb59bb79a6e"
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
