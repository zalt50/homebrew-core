class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/8c/9e/b4772f3c942a00a1ea7cce8055958e503292d314bff51feda1429a271f7a/dvr_scan-1.7.tar.gz"
  version "1.7.0.1"
  sha256 "f7036f8e679cd14bb61417266b1f8cff4f365a00227bff3d6ed75200f33e5c53"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee8ae5bc7ff402c690a94b738bf97f53cf1c60509740196eebd06efa98526a38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f241fb1c8e811c48f6fb77b6480bbb3887fc68e3f7a0caf87c55a4e0ccbd3caf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6939c68d80fd38b540ebfdd2a513c8f617139186d1c4f0c0bcb949e4407e272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99cf90f97275ed4f15c0df16e89b0a76aba05eff89d663590706e25c872c73ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "db13e965368275d45493590b9190ece8b8b3fa5b44def90c09e80464cf73c39d"
    sha256 cellar: :any_skip_relocation, ventura:       "21fc1c751146e9262683b5788088da87d140060d465b32697ef39e62f15a493f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68e2e01e1fb8692745806ba12158535eec85f95022b0bdbed80632dae544b92"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/4d/ab/4e980fbfbc894f95854aabff68a029dd6044a9550c480a1049a65263c72b/cython-3.1.5.tar.gz"
    sha256 "7e73c7e6da755a8dffb9e0e5c4398e364e37671778624188444f1ff0d9458112"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/ab/dc/6d63019133e39e2b299dfbab786e64997fff0f145c45a417e1dd51faaf3f/pyobjc_core-12.0.tar.gz"
    sha256 "7e05c805a776149a937b61b892a0459895d32d9002bedc95ce2be31ef1e37a29"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/37/6f/89837da349fe7de6476c426f118096b147de923139556d98af1832c64b97/pyobjc_framework_cocoa-12.0.tar.gz"
    sha256 "02d69305b698015a20fcc8e1296e1528e413d8cf9fdcd590478d359386d76e8a"
  end

  resource "scenedetect" do
    url "https://files.pythonhosted.org/packages/f0/b4/e77e1812ae89bc4864ff54efb6a8232eabebd471e372096cb711f03cca52/scenedetect-0.6.7.1.tar.gz"
    sha256 "07833b0cb83a0106786a88136462580e9865e097f411f01501a688714c483a4e"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  def install
    # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
    ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}" if OS.mac?
    # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
    ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699

    without = %w[pyobjc-core pyobjc-framework-cocoa] unless OS.mac?
    virtualenv_install_with_resources without:
  end

  test do
    resource "sample-vid" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end
    resource("sample-vid").stage do
      assert_match "Detected 1 motion event", shell_output("#{bin}/dvr-scan -i sample-5s.mp4 2>&1")
    end
  end
end
