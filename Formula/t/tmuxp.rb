class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/78/96/6493430a31ecb2c6e36292b758be70655e01802575008d0de77d728f271e/tmuxp-1.74.0.tar.gz"
  sha256 "9e0480ea012999602635887e0461d395c2d8aa6e36a85b5a6d1d65dcd6c7809c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37cc4cdd6444ef68b64586e28562bda7c776283c9d55326c844a6cef061ceb30"
    sha256 cellar: :any, arm64_sequoia: "380e3b703a83e90e790eef3bbf99d832fb7e62c430f2ee28d81f936a906c389c"
    sha256 cellar: :any, arm64_sonoma:  "1b616c1ace2f943fbc2381298ca6606aef95b81f520c55eba5e133fa8eaf8b71"
    sha256 cellar: :any, sonoma:        "ac4de67b0cbc28d3db8188ce9813040c701e661320a3edcac177e73deaf70854"
    sha256 cellar: :any, arm64_linux:   "76775d536b00afb09ca4ad37b7486fd483d165e366934339c19f776582252493"
    sha256 cellar: :any, x86_64_linux:  "58fd2928337290424efae00363085015d49a5e1cee918cbccc4fdda4b03c4c89"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/c2/6abbac4420c35b3f1140c72607117236b160173f74fd86941f99b28375d5/libtmux-0.61.0.tar.gz"
    sha256 "2d6081081a629b9236a36a64f874667533811d2ce5a1b0caa9c821f4d9d2e618"
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
