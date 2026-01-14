class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/cd/45/fa851fbb1ccc0ccd60cec0decbd184c0264f96ac43c7b656986ed0474bb8/plutoprint-0.16.0.tar.gz"
  sha256 "098e5c244bd7a59697afc09d372707f2f98a89c6f23b76beb579a78648c9c354"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17f45618649131161e05e3204883aabad093298ab2ab119bbddffbcb39b2465d"
    sha256 cellar: :any,                 arm64_sequoia: "99b48810c1a04f03c7ba323cca4221ff0352e8c7fc70ba4dc59ea3d7b01c4b7f"
    sha256 cellar: :any,                 arm64_sonoma:  "850d59bfaf0204f41c3c0147fc4419bcdea3e03ccfa4397cbc6e48acbb4955c7"
    sha256 cellar: :any,                 sonoma:        "54032fecae05c063a5abb765166e11cca0a0a814ebe66cbc8891d59b4fe8c0b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad392e74ae3c83fe0ad41b8f27ab19742e8baadb15057c685def1eb8d469326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1aaa333600827faa4f61fe54689e24c7a8c28a9ef4446afaf31844aad22f8c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
