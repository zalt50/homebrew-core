class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/21/80/76f05a152e7fe5bc6e9351ef5cdb8eee06029e18fabd95b178672512fa03/nvchecker-2.21.tar.gz"
  sha256 "65eb04a74f261e25f62f1678a4b9dbef905c9e3b82777c69d894a1643fbec557"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d699f142cc374c0a895e4a893a04c3b56e3575892de58128d974dc093a2a8768"
    sha256 cellar: :any, arm64_sequoia: "64ce4747002595ab0d3c45e69cbe7bc81ce87522222242bb08a8ddd7d6e6cdbe"
    sha256 cellar: :any, arm64_sonoma:  "82d6b76fd3b7ffa3a20c59f300afc44a55994a2c73b724f3def44f5849897efd"
    sha256 cellar: :any, sonoma:        "dcdb283a0815f9176dbdfedfe9de641ed72b17d6e221d97b92beb028a6bf06d6"
    sha256 cellar: :any, arm64_linux:   "5b6699ec829df0ae7cfa109f2e5cb9d84087dc709e0dd73764a3b0c2e3e4f023"
    sha256 cellar: :any, x86_64_linux:  "92d4851e954d99535e3e7f5cd986f55adf24985c36644b517950e15f1c58e0a7"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/81/bc/705aa3bc36b99946a128d068e1afd4b6f3eebb36c6b97f551f3d2d740460/pycurl-7.47.0.tar.gz"
    sha256 "5e3cf357939da8d4ceefe3c7f305afcf9b47cba66cfd95e7768ca43b38445e14"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/24/95ec527ad67b76d59299e5465b3935d05e4294b7e0290a3924b7487df30b/tornado-6.5.7.tar.gz"
    sha256 "66c513a76cda70d53907bc27cf1447557699c2e95aa48ba27a442ff61c3ddfc2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
