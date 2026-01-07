class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
  sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "33888a9490da2353b6c406720f5ee76632dda00d23908a5e894d0504631cb257"
    sha256 cellar: :any,                 arm64_sequoia: "1e185521f70899c61ba2abf08ce758d5938c41ce47d1f3a76c40b4674221f22e"
    sha256 cellar: :any,                 arm64_sonoma:  "b81a7d886d5107f84b14b852921d16008511bafbadbea2083999e41bb6dfada7"
    sha256 cellar: :any,                 sonoma:        "0596347f159ab37c97b4f145bd5ec27ec0ee7c5e273cdc30e97d56935400cc63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c78abd8f4331923591216dfb62cc5f23c3150a4124f8038800f172996d556e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5ec0e65f904a79dbca7f6ac68daca3ea11ac1de9801face0f38f29d97aa8f1"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   "decorator"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~PYTHON
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    PYTHON
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
