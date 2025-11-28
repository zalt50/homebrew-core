class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/33/f9/0e84d593c0e12244150280a630999835a64f2852276161b62a0f98318de0/fonttools-4.61.0.tar.gz"
  sha256 "ec520a1f0c7758d7a858a00f090c1745f6cde6a7c5e76fb70ea4044a15f712e7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ad82d14b727b99fe1b9600738327b1eeef5f666685220c3417258204755b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42312742d0d4e3e2e397c956c94d1ba7b4c03b26e47522f21ca8a467bdccb288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933704c12dd547642f635357461f18e04e769eae241e4ae611394dd831875dd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb7ebe84ed7b3201155eea6f4efc142970ce8821b852f52d39504d7a2910975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f388dee9dc5a5966a790e735d0695488b50354e37a07b2a29365aff21a3217e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81dc5cc04a1952a9d5fb3b277132edc0e4640aa7a217c094eee1d7006e7b67da"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/be/4c/efa0760686d4cc69e68a8f284d3c6c5884722c50f810af0e277fb7d61621/zopfli-0.4.0.tar.gz"
    sha256 "a8ee992b2549e090cd3f0178bf606dd41a29e0613a04cdf5054224662c72dce6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
