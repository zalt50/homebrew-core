class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e6/ab/2950ee964979aa31efb3e0e960f2055d6b1efec5c6239483f88ca6713fc9/nvchecker-2.20.tar.gz"
  sha256 "79cfc9eba3170405db5b1d74475f2e0b539d708c869a7212b40e803e033e0149"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bca1850cccbe81c6a15eb58b0e5d9946dcf8040c201ea181358621ea3bb7577"
    sha256 cellar: :any,                 arm64_sequoia: "4fa7d164d186be639e5c6291e52cfa548ee0af0fae7e107601229f8983a13a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "832c14f48d73dab8c7d2ee6bafe1c5d1897b23d53c9c283d5c9f2cc3b7688f3d"
    sha256 cellar: :any,                 sonoma:        "499b438420acb117d89f6cc0b2cb19a8167b1b3d87cc3c916f77e91edee19570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6924516ae78fbed84bee02e88866c7eaff317fae1945e1469f40d090a3a9552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebfea056a82946370572ad1443e5cf25663f38ae58b54136a995b53b4e1ef4a7"
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
    url "https://files.pythonhosted.org/packages/95/23/cc07b16591af8ca373494d29aafc8df13e547077579e6779bb865a3f5a7f/pycurl-7.46.0.tar.gz"
    sha256 "422ed7005b98768fe60fe6b6cb8bb6a4e1fc18b5433402e8fbdaba91811c4604"
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
