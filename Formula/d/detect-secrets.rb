class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
  sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  license "Apache-2.0"
  revision 10
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "819838349cafc1485e6fb9d5d0f8d83b54478fb0859b1f8bea31b953083ebf4a"
    sha256 cellar: :any,                 arm64_tahoe:       "d5795a3c7fa4dfb29a132b8f19340a262b8a09dc6c8cd88970c8a565d331f0e9"
    sha256 cellar: :any,                 arm64_sequoia:     "9564051ad87e0ddfb45b29ecb9649e7f89403a38016538cd68246d64049772d7"
    sha256 cellar: :any,                 arm64_sonoma:      "3dad3e74c2e218d0d220b28807049f8a9237b4067303e85444069202d961739a"
    sha256 cellar: :any,                 sonoma:            "fee21a7ca788089e3e35ca35bcaf71a8d23ea9d06c7269d394cae00d4454b5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69140d30b088476230f231e9a858c865ad7e0c56929f976d900634a2bdf04787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "edeb9324cf33979689a0a9c37db7a4181b8cba17e0e9096ad5e7a60244856884"
  end

  depends_on "certifi" => :no_linkage
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

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
