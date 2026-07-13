class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager"
  homepage "https://dooit-org.github.io/dooit/"
  url "https://files.pythonhosted.org/packages/a1/dd/96bfcde11415f846d8e4bf2ec494432aae4e6938c6b3ef1e9db3a854b45e/dooit-3.3.4.tar.gz"
  sha256 "ec9022168c4a4568693590840aba0b859cdbca27872f1bef84e39d64c044acd2"
  license "MIT"
  revision 2
  head "https://github.com/dooit-org/dooit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db0b83ac3edc7b87bbd0cbf4caf96e9e31771b5030b025bc59c9fc64059a4329"
    sha256 cellar: :any,                 arm64_sequoia: "f8f54323ed981fdcd0d5654bd4f99217db0bcdbf454752cf60c6a2ac3617b62a"
    sha256 cellar: :any,                 arm64_sonoma:  "0dfbf076a23ff15936a642544971bc2619daad5c4d692932142eee24b0ba60cc"
    sha256 cellar: :any,                 sonoma:        "abaa18b170f25d81355e8989fab6a3423a07fb066d6ac92ae3bad98c6f3c5a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58054e7a4c256cfd41d778052a7042899525b3a5bdaf6c747dacefa1021073ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc3e8abfe180cd8304884f5c96f16564aa676e75d5b5bc388d95135936198ee1"
  end

  depends_on "cmake" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/02/f1/a7a892f18d4d224e6b26f706531eafccc41e37594d37d304786969ee13cb/sqlalchemy-2.0.51.tar.gz"
    sha256 "804dccd8a4a6242c4e30ad961e540e18a588f6527202f2d6791b01845d59fdc9"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dooit", shell_parameter_format: :click)
  end

  test do
    PTY.spawn(bin/"dooit") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # Create a topic
      w.write "a"
      sleep 1
      w.write "Test Topic"
      sleep 1
      w.write "\e"
      sleep 1
      # Create a todo in the topic
      w.write "\n"
      sleep 1
      w.write "a"
      sleep 1
      w.write "Test Todo"
      sleep 1
      w.write "\e"
      sleep 1
      # Exit
      w.write "\x03"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
