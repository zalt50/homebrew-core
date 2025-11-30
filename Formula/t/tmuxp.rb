class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/31/cd/891706fea235c6298b472345108d52c8652dc95e0a8723beedce19f0f0f3/tmuxp-1.59.0.tar.gz"
  sha256 "a801caf10a0972e2455866d39e3daa3fc9d87140022bcde0747ee275e3429f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dba6f2d441374e3181e0aba75696f4e675b47245dc8ec7a321eb214e5ed2702c"
    sha256 cellar: :any,                 arm64_sequoia: "5efdf8f9d707a97f2f0fc19fade7f4756bf9ee4434fcb4bd1e4c4c0b6ec12cbd"
    sha256 cellar: :any,                 arm64_sonoma:  "7c57e9bb0de5fe01a49a36b44a30a0d08703b32455a4c17c9250cf41f9545076"
    sha256 cellar: :any,                 sonoma:        "3cea418837f12fc7a4160b820470d9197d5405bdf3206be52d88d241026e39c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "383831625364496cca9e31a209d03f266f9401c2372c21e5f488fbe51f77bd14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f258995e413e111ea259d3c2b20cf18d2871b5ecc10544d9801b3e83093769b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/8d/70/2c126dc1253c674ae01e89d63078f9b6a6ff3c6e224bfd1ca1fd3108751f/libtmux-0.50.0.tar.gz"
    sha256 "7e3ae83e7e216903b311d7db25b3d736a1cc3ae61469ff0d5b6b563f6a92c3c0"
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
