class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/3a/c9/43b63b5f0ddc53c25052de75945dc4adc6b14984a38e1dea72c34cf398d7/tmuxp-1.67.0.tar.gz"
  sha256 "990720d9fa5a6f4758790aecc201d2d29af0ad9ad8c47b58ac20acb0e8a94f12"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b8e9ee341c13e90568c4069b002cd7fca3e30a4a57abc0f343e687795029ba2"
    sha256 cellar: :any,                 arm64_sequoia: "29acc5784191a7e8ee7824523b9f94128ccece36759a5ec1b30f96d3f6f3628c"
    sha256 cellar: :any,                 arm64_sonoma:  "4786add0cb6d7b2c1d2847b9e4bb1d26b529cb28ac37697bb46216a2b16e472b"
    sha256 cellar: :any,                 sonoma:        "56745ef5db1b8d672f811903545b8aa7a45446c267143969e84c129731e6c42b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a4351a5fd6ee9623c059a3d7d00c7150fe645a89ae221c65ebc702393b9a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d273949c3cc6e9a926b68b0ade6274d32033acc4ca72bfa6891705d9e886b7ac"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f7/85/99932ac9ddb90821778f8cabe32b81bbbec280dd1a14a457c512693fb11b/libtmux-0.55.0.tar.gz"
    sha256 "cdc4aa564b2325618d73d57cb0d7d92475d02026dba2b96a94f87ad328e7e79d"
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
