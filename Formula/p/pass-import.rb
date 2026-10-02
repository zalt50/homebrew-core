class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://www.passwordstore.org/"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8caeff88ea7fe77c5643ea8e3d2d53f4b4cc6d650b583dd912cba571483c9898"
    sha256 cellar: :any,                 arm64_tahoe:       "e05e35a7cffcc047c2cd7c3fad599cf7a0c419b7d83645db51f785daf673859c"
    sha256 cellar: :any,                 arm64_sequoia:     "9ae721ec82e772a31a34d13543bda6a6a6268f1206768ef4220781f68b7fc73e"
    sha256 cellar: :any,                 arm64_sonoma:      "ef101bca53c08111af4ad3557928900eaa9a0d8939a4fb4d8faa578db78070ef"
    sha256 cellar: :any,                 sonoma:            "2f060a3d41c5a88bf40207232dc9da0f4ecaeea6e428c45f86703ef888e2da91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1bbd057bff2470696ac5ab9b63ffcbbedf814ab7f83fc80a4f39acc9ae3ab062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ff6a55fecbc4d90b57b98e67d19712e9236e8c84f2130a41cc62b09c14e6a55d"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/15/6a/acfdf17de0d6947b419da8696e02b781b18de2cf49e0472298b50e1f0711/pyaml-26.7.0.tar.gz"
    sha256 "11cda3a796efc6dbce0d56836be56cfd26289dad07bcd78e9904086729929c93"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
