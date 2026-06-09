class PulpCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Pulp 3"
  homepage "https://github.com/pulp/pulp-cli"
  url "https://files.pythonhosted.org/packages/f6/05/6941c31c0bde2626d95450ca617864c363b376c5853ba8282f37ce42d48e/pulp_cli-0.40.0.tar.gz"
  sha256 "301ab4b61d6833d0b6d1c2aae7c50d0fc2920bf0ac99b112cc84971fa483f216"
  license "GPL-2.0-or-later"
  head "https://github.com/pulp/pulp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5947d94eef23e08cdb6638ee4ee9886613fec9ff37baf16fe3c42290dbf839f4"
    sha256 cellar: :any, arm64_sequoia: "dfb65c433bd520f14869e2bb8fa3eece687687bbcbc45abeb05fbabe06ccdce8"
    sha256 cellar: :any, arm64_sonoma:  "b4ba76e5b81ec50abc21c658fa35323ab088d5e0d3d89eb94f28541678db680a"
    sha256 cellar: :any, sonoma:        "158642db8676e36148cf598f0de1cf6d81f158b4b5e20b9c816f64f1cb702b9d"
    sha256 cellar: :any, arm64_linux:   "371d4bf987b6f15d05a7d2bca9a15af90249bdc8a4ccb538b38582c995c89b40"
    sha256 cellar: :any, x86_64_linux:  "f41b4eba17adec5b2e331560ac0dc8b0c62b4848f92c4df88795af891a8a5d0d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pulp-glue" do
    url "https://files.pythonhosted.org/packages/69/99/c5d12777beda91b0f68adbfb14126aed9fcfb0ee22c0c1b754240485d07b/pulp_glue-0.40.0.tar.gz"
    sha256 "3e6bd6c9ad6b515365c14dd80102a8aa881895f76f6c9c6ab96c9aeab741f349"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pulp", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    (testpath/"config.toml").write <<~TEXT
      [cli]
      base_url = "https://pulp.dev"
      verify_ssl = false
      format = "json"
    TEXT

    output = shell_output("#{bin}/pulp config validate --location #{testpath}/config.toml")
    assert_match "valid pulp-cli config", output
  end
end
