class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/ac/03/0b438c6b708e0c3f22f71d87dd46bc054ab720f5d8bbeac520d8468e93c2/gersemi-0.25.0.tar.gz"
  sha256 "5b19c70f5e9e575127ca019ecc13d1c61ca59cbddbebd0688ce08864c0d7f67b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f98f42c3ba8af19df31279bf7d490589fe0124087946956948cc92293a90aef"
    sha256 cellar: :any,                 arm64_sequoia: "cf3932f1aa97ba0b048ff2db85a33aaad47f9112b7aaae14f305acf0c644bb45"
    sha256 cellar: :any,                 arm64_sonoma:  "5172d48d61fbc622365bf846dd1a14296d26cddf4c8afff28cd274e59eb7f7aa"
    sha256 cellar: :any,                 sonoma:        "6c0493068a327473b97668205a56798c9c21a491597dc21c40de5bb06c9ca526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2463ed7861195badb5c11438d4b06c02a7a28e26d51acc2a8be7e95ace67257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2c881558531fda60425a7e2ebff40338f4fca5444851fbc76105e659b873a4f"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/fb/d1/fd458543147240d9c154de5205b87911b37cefae5841d9034459acec7db5/ignore_python-0.3.0.tar.gz"
    sha256 "7c3d255c51b36310daafc78b16a61b5e9fffbb5d1e3b5675b36ddc4ff8630797"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
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
