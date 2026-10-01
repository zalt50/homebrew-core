class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/44/29/cd80e9108a6fc6a925ffb915f8f69198a2bb2388e39167a41d743ac2a8f4/bpython-0.26.tar.gz"
  sha256 "f79083e1e3723be9b49c9994ad1dd3a19ccb4d0d4f9a6f5b3a73bef8bc327433"
  license "MIT"
  revision 7
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dda8e51dce2ae8c667b2ab1c5498576c7ce2ee70ffc2e0cfe48b52fc231a45a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99600adc9aa1fc6608bc0e8ec461116814b2a670c53fb0df0553ba8efc0ddbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a641141089968a765d235d82c6bb1425412bbffadeb640995c6c6c5573ad5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8e47071bc0cde4cc167e1c7741d3b2f4c0292ebcd731db448b89639ed0b64290"
    sha256 cellar: :any_skip_relocation, sonoma:            "ea4ceef6472766528cc021432956652329f3c3f5109ec54447fc1ea1d7ab9df5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8b3d9bd31f5ba12657b184598c497ab1bab286ee8a453b3348bf34a7607ca52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a4452730f8698510e1d09a2b4681c525b2929999988ba8449a224c34637111c4"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/7d/44d82d953d9bbcac57fe26507ea7ffba65ef1ec8f41f2b58da2fb12ef26c/blessed-1.50.0.tar.gz"
    sha256 "046c9b2a5283a9c5bc340ed23b7d1c1f10ef2d7fb30b14bae13ef7ffc1f3ba56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/86/5f/f5c3d1b4e9c8c541406ca0654efa1bfaa05414f8e7d1c14bc6e3fd0752f8/cwcwidth-0.1.12.tar.gz"
    sha256 "bfc16531d1246dd2558eb9b3a63aa37a9978672b956860dc5426da2343ebf366"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/dc/ac/3a943d2792c9bb368aaa8b50121c0f778460ba2d7fbdc0a0366201d9e761/wcwidth-0.9.1.tar.gz"
    sha256 "5823209b0d43af322ce698c689380d7c15ca31fa8e6e3be8459f27031bef0af5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
