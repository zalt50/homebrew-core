class Gruyere < Formula
  include Language::Python::Virtualenv

  desc "TUI program for viewing and killing processes listening on ports"
  homepage "https://github.com/savannahostrowski/gruyere"
  url "https://files.pythonhosted.org/packages/16/0f/d951dda46ba3b3dcbdf14f55355130b016445f9aa6b021dd70a9a567026a/gruyere-0.1.0.tar.gz"
  sha256 "3fe1ff4eef9a53ed46f17a7aa5efa2eb0212a2c6de618c2b36735bcc71d358be"
  license "MIT"
  revision 2
  head "https://github.com/savannahostrowski/gruyere.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d1b48d44a3433291a798e417cc844f7448aafb949b0f533d10b0711ba55d93c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c82a0b330b65e5c4afb8c451c38977b719e7fff9ace05d212bb1fe8de50a89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56bddc4970aa1d0e21f68267f0dc0c6414cee2a0e8809bd4736516b5c4d0ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c80c357c86174ce2707d6591e95541769ab7235cc9b530b7daa61d59414b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd39ee2bd91ce5180df116a6cf31ba687b62dd1bdc02a4a7d4ceb11bd505db86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00b20fe9f56d71ec66ccc5a4f51ac823432db2f1379754b448e11938b155d23"
  end

  depends_on "python@3.14"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/7c/f7/68adc395201b20b872d68e975386832e8005ffeacedd43a1d837a32815be/typer-0.26.8.tar.gz"
    sha256 "c244a6bd558886fe3f8780efb6bdd28bb9aff005a94eedebaa5cb32926fe2f7e"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gruyere", shell_parameter_format: :typer)
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"gruyere", "--details", [:out, :err] => output_log.to_s
    sleep 4
    sleep 6 if OS.mac? && Hardware::CPU.intel?
    assert_match "Here's what's running...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
