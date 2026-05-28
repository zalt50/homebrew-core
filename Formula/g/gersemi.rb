class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/01/45/93f06bcc8fd631e50875ae70c542de7a46e6a06b9e19f39fb903b61e8ac8/gersemi-0.27.7.tar.gz"
  sha256 "f598d62bd2bee0b6cbfc4e71f82c86f768ab31d135a312585fabbd7e57b64e09"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "433540c3222e7f6708d1c549522d22d06874b1c228a78417fa86910c2cab2f14"
    sha256 cellar: :any,                 arm64_sequoia: "53835b3e5dc59d94814c1257affbb96b01d4a76fbd920e5f217163f3a9467a9a"
    sha256 cellar: :any,                 arm64_sonoma:  "e32109b0591b88ba711f2b66379bcd7198833598b2702af04f8386521a79e3ee"
    sha256 cellar: :any,                 sonoma:        "073f7e293f40793e8505101fd0b449dc2e4c8f835d7c32b7bf4600550a152b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e030dd47c031694c41a9be529a6f447a265b3f6a31befef6e92ff504b40cdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b83d307ae52d43ccbd5873e59bbedbb55e5595044b2139207dd76f42cbdaa74"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV["CARGO_VERSION"] = Formula["rust"].version.to_s
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
