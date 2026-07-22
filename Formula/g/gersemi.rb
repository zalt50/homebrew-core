class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/96/3d/babcff7d305561ebe96124298dbb7e3acaaa21f04a6490a8f0987130233e/gersemi-0.28.0.tar.gz"
  sha256 "984b488fd7b4c6a77fb41e4291ca63b08fc2dfe46a722b6309e23b4fee5df7e0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40f514ed646f3bf4011cfb96147ddc9cb28082abf22570852f721d6318ebf8fd"
    sha256 cellar: :any,                 arm64_sequoia: "a3a38b689dc042b47791b588bcba5a0448ef5c4890c052397de5a5f3d35adcf8"
    sha256 cellar: :any,                 arm64_sonoma:  "57bafcf2c4fe5ec9c02ced9efcce5b2f8c62f67c7698ac5361340b427adec6df"
    sha256 cellar: :any,                 sonoma:        "9bc9bb2a19cabc5c012e66248b0a8c8a2bb13af7255b713498b8eab71de6fd99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eef01191c2f4bd8de66b0375069d379051efd53eaa25c847b4cfff864ddd09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94f56fb57bb2ca8b7352b835a2a20b01860bde387f519b4353a22da8ed5da1c"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

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
