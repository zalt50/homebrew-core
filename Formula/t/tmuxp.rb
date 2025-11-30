class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/79/5d/2f8840e9548e7c82ad6e0653800a6bf2235a2dd92ddfa30a6a595d555594/tmuxp-1.58.0.tar.gz"
  sha256 "54a321e939a95a47e902cd840e0f392f717f3c59557edcb01e2b893bc1c3618c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f16c914b4a49b4740ffc5f2d1d990b031bb5b1ce6d37bdaf525d83d3985cd489"
    sha256 cellar: :any,                 arm64_sequoia: "b737f150880f091df3ece46468e93a59584ce8f312ce8d886c32f88585873458"
    sha256 cellar: :any,                 arm64_sonoma:  "1342c292614f0064d2b0648838ce11584c90e911e19ec0b12446540dd72138e1"
    sha256 cellar: :any,                 sonoma:        "1c54df5fa2ab337f774c199587b4bde0918062cf0e9aec8ac0c49e528c29cde4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece410205ca061cacc0b9f5915626e73dbb5c884eb873a1c3b13eeeb61b58b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920cca799efa12cc1630074143033bb346bcaefa2fa2a4e04658f2d5fe2c1970"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/27/0d/1576939298d16177872a55b55d50f8f3169bc016bbecdc64979ff9fac3d4/libtmux-0.49.0.tar.gz"
    sha256 "f462848f5712776910b71a1ccb79d19b54467cf2afd24f2a5d0de4f40e751706"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end
