class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/44/7a/41c143d0e922fe6a2bd973a88c32bf109acf9f49c93b12ae1628669e233d/yq-4.0.0.tar.gz"
  sha256 "cff60829168ccf30392257215eb66b85dc1690530bdb48bea53f37f1b24dd1a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "994933fc91e4cba44207c7e3315bcc4aaf1bf4843c640c5808674553b7b8e859"
    sha256 cellar: :any, arm64_sequoia: "57cfd67325d5d3039d96939669b56c603bbe8bb6f526c56f52c2ce7ee956574e"
    sha256 cellar: :any, arm64_sonoma:  "e71313720ca78d746f50b401bad85805c5ea0c1d359e97670ae0f61777e6f443"
    sha256 cellar: :any, sonoma:        "1e1f92d20fda3de8ba05d390c2f535d74b2d620648ad9cfb29b4dae52439cae5"
    sha256 cellar: :any, arm64_linux:   "d92393c1ac3993551503038e2b175c47b2d05c6ba93dbc82d2408f8afa8a8e4c"
    sha256 cellar: :any, x86_64_linux:  "b51c8522af969d61cd1a548573cf0c0a517ffaae649365caa3fa5d2919f5b756"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/51/db/03eaf4331631ef6b27d6e3c9b68c54dc6f0d63d87201fed600cc409307fd/tomlkit-0.15.0.tar.gz"
    sha256 "7d1a9ecba3086638211b13814ea79c90dd54dd11993564376f3aa92271f5c7a3"
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
