class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 4
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39fb97daec07a2e2afaa777ab9e7decb4de2f2c6aba92368eb34f5559f01ca61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c016ce47264192f694be56ef9a9da7b4507447a4ec2fea4ffa3c68778975f911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7f0c2abb2a19edc3f2c809974abdf609035da5473593f8f34e6b6a1a12befc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdadf165dd2f228dc45df5cd7708ff0b76659762d1f6bc429de1c621298e27c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ae1769694653c05cde760892623a734d5793d8c86facd3e1cd45b50e64cb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07600909a154a7328424524eb6656bac2933a8fb4a588aef301c6ee24a04c1f7"
  end

  depends_on "neovim"
  depends_on "python@3.14"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/dd/8b/befc3cb36965f397d87e86fb3b00e3ec0dc67c1ecb0986d7f54ee528f018/greenlet-3.5.2.tar.gz"
    sha256 "c1b906220d83c140361cdd12eef970fb5881a168b98ee58a43786426173da14c"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/04/d7/c4412e6219661fd8689cdd9553988f8ea38c151067d70c49436977688aa9/pynvim-0.6.0.tar.gz"
    sha256 "0ffcb879322d08f9e9061e1123dd58ba3a5ccfbd4999bb1157bac525822aa590"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    socket = testpath/"nvimsocket"
    file = testpath/"test.txt"

    nvim = spawn(
      Formula["neovim"].opt_bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", "--listen", socket, file,
      [:out, :err] => "/dev/null"
    )
    sleep 1 until socket.exist? && socket.socket?

    str = "Hello from neovim-remote!"
    system bin/"nvr", "--servername", socket, "--remote-send", "i#{str}<ESC>:write<CR>"
    assert_equal str, file.read.chomp
    assert_equal Process.kill(0, nvim), 1

    system bin/"nvr", "--servername", socket, "--remote-send", ":quit<CR>"

    # Test will be terminated by the timeout
    # if `:quit` was not sent correctly
    Process.wait nvim
  end
end
