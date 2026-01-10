class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/13/94/6674d6f4955e6c45436fc8cedfc480d2d889bb07006951dd834db84fe28d/osc-1.23.0.tar.gz"
  sha256 "54a6d3d7ffc0d4952c82433394ba05d562538feba56b2d3b611ce103f8e8b724"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1d6396deb2fbbc1233ef0980ea851ba3f162fc1129fa4089133496d4be0cb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcaa3ebcf51ed62de6a6128a493ab4e84acbd14fd8b2a5c8634eb6bea1cdf781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646ee620734e36e31b7b4bfb0746d3ecbfdd944204a4bf9f41d7e932e985b0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d338106ba0e5a0155d4f4d9fa9babc893123cfd50447f6211a16dba36838478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c33a12a497773820ac28094e1d8e78dd964906c36f017993b01b0e4f880dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd41a271ffec53d78d39567b42c03653a2eedd044515b5c7197de72caf82041"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpm"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  pypi_packages package_name:     "",
                extra_packages:   %w[ruamel-yaml urllib3],
                exclude_packages: "cryptography"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a Git SCM working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
