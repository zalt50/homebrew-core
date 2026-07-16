class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/12/9b/b5a1ad047af188983eac294cabad8492d0ffeca48028f7fa37aa18574e11/translate_toolkit-3.19.15.tar.gz"
  sha256 "d4762323eb27dcf344de4ca5050ae67a9fa84b06b6b7f0f486c12970a363c96a"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c09b98d98d38c72106b85dc93292a881f7ba14be404e4810615fec7c6ae2d7eb"
    sha256 cellar: :any, arm64_sequoia: "f9323d7593a32e949464f70b4718e4c8fbbfe1679f935409ed2e3e8e4db905e7"
    sha256 cellar: :any, arm64_sonoma:  "9698f1ac4ffdca39b72d6cb5ab845270e7fd4dfa37392ff422a56e788ca61fe2"
    sha256 cellar: :any, sonoma:        "4acd96244d5f94273ffd8ee4cf1c0002d473adfd54053e509cc7c66c353a9385"
    sha256 cellar: :any, arm64_linux:   "864a8a12ee549056142f9bc96370a9501f2d6458f695c408fea1b83b183b4ce8"
    sha256 cellar: :any, x86_64_linux:  "d6e5b398abd61651c90de8a88da37171e2ebc82684497a1a3fdd008897a0d591"
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
    url "https://files.pythonhosted.org/packages/4e/71/52f1a87120d92eafbd56c98e0d7abeb10d097bbd3dfb697bd8bc1dcd9070/unicode_segmentation_rs-0.3.0.tar.gz"
    sha256 "6178f1097f3b1bf8098b43e35daea302c994a738f786b807890ef6ace21abf94"
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
