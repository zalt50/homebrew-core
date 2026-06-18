class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/78/02/5e5c1e67652742aed7e7a586ab1ff23566ad697e1e605ad326180a6183af/tmuxp-1.70.1.tar.gz"
  sha256 "ed29a9d286bfc81b8ec338a804414a54959f8cbccc0f83ebcc1f323fa55e7a95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c62f5524b081743fa8adec6543d576443f5a48b72b3c251fc4e1fbf9462093a"
    sha256 cellar: :any,                 arm64_sequoia: "e40dd945d9a3b42d12b58503ba0be70b6fbe8329c561c8522ded6861a74dfb29"
    sha256 cellar: :any,                 arm64_sonoma:  "ec32b9545c428056934883ecc739cb1bd6af78a22054bf19518707ec7da93cf3"
    sha256 cellar: :any,                 sonoma:        "f3915737f6e07a24926e576c4be9b21da7b61b8104cbea4d12e51a526d22126c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9ddeefabddcd50239cac062b9ed8c04ae666412342f0aefaabb8c6c7122d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b319299adeb05a4a35b4ef8d679d252a2e5afa8916b35217b581aa5ef4388f"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/c7/58/346776e0491ede33e1554a4bff9b545dbe9f3164e45abac483195938a1cf/libtmux-0.58.1.tar.gz"
    sha256 "a294dd585aa419d4ecce36f3e55df656693743c97a0b5b5bb1e5fea31ada2482"
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
