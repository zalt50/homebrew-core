class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8ebdbfba133809bdc4cff56aeab7fc0d7f1704725893d507eb306a0fb3ba550d"
    sha256 cellar: :any, arm64_tahoe:       "594da078c3449f65cdf95e9f9d4db59c7243e42a808ba455ae261d8be2da400a"
    sha256 cellar: :any, arm64_sequoia:     "787b7cf47e3a4f973bc0d8101ca56d9b8de4ede7e32aca37aa99e77cabd97cc6"
    sha256 cellar: :any, arm64_linux:       "4d3fc5dac03004c53c22d320470e9bd4155ae04c53a09bea085a4a026c1f140b"
    sha256 cellar: :any, x86_64_linux:      "2b8a0c6294a31964bfe75388a0f0c22dac248230b79f14c936176eab679c8abb"
  end

  depends_on "curl"
  depends_on "openssl@4"
  depends_on "python@3.15"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/35/e9/bf409046a91b6a9ca652e9b0ac3c39481674f6774e23e58b52315516099a/platformdirs-4.13.7.tar.gz"
    sha256 "f7f351c027d6632c30471124e1fdb6ac0fef9ccc5cbac1b34cb333431b1fc3e1"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a6/b3/93b9b8b4ed45f4700b3f9fc40b5daf189e0badd71d0839a6ad09cefa2245/pycurl-7.49.0.tar.gz"
    sha256 "d4327da9dea72768f942f831bbaa5a64adca4d7c89f3141da7a833d3c600ab90"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/d0/02/5f549b1ad5da6267ed1e1fac2eef69257b1979cc812497002499b7895ff9/tornado-6.6.tar.gz"
    sha256 "34c4aa916d7f2b2d5cadee2c6850f5a4a7f3d688cbf58399ea9bd3057af4abd5"
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
