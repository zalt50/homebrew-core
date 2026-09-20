class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e1/5f/212c5a30bb31e9c96bb89455b7c58213ef22f1a24e2497b743ef8092004d/yq-4.2.0.tar.gz"
  sha256 "53854078bade13fd69eef85d77dcc513125a0bce2f8f1ef8b466e655ce1be9e6"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "baa271d0f11db1e1f19f217ad12c756a7fc6172652cf7d376397f633592149b3"
    sha256 cellar: :any, arm64_tahoe:       "e9016d2edb8a0d702385cdda32ed29643e7a076f6473eb74abe81cff2cafbd6f"
    sha256 cellar: :any, arm64_sequoia:     "7d68c10b735df0d92efb05581382386e7a2d9754fbcc0ba508846c55a0bb17a0"
    sha256 cellar: :any, arm64_sonoma:      "6da269e23799b52e2faa751cecc8855abfac606a93b19714671b19909b0eeeaa"
    sha256 cellar: :any, sonoma:            "502df9372e2f375a1a440bb50345440ba348cfa02b8e986dee4a91dcf9d9ad26"
    sha256 cellar: :any, arm64_linux:       "816c7466bf03f39a0cc7c269c3b64ac3f10c72bcdc6533cb8fdb7350aedf1c27"
    sha256 cellar: :any, x86_64_linux:      "cf2f01f310536e287a0b9dee791569b025a1b3fbe0bf839c1cac23ae2e56ea75"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           base_name: script, shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~YAML
      foo:
       bar: 1
       baz: {bat: 3}
    YAML
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
