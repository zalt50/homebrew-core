class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/56/3e/9cca699f3486ce6bc12ff46dc2031f1ec8eb9ccc9a320fdaf925f1417426/scipy-1.17.0.tar.gz"
  sha256 "2591060c8e648d8b96439e111ac41fd8342fdeff1876be2e19dea3fe8930454e"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15f20a5c8c7b898c7aef6f9661757a50bde0240b9895f58f7ad7b10389385257"
    sha256 cellar: :any,                 arm64_sequoia: "ae4cdbadf3a897bd5f764392f544c1b89f2ba422bacc41aaff20dbbc3547b76c"
    sha256 cellar: :any,                 arm64_sonoma:  "df5260adee8f5e6dc4aaa511b3a3422f0889ba72b736d01931bbc35c5d535684"
    sha256 cellar: :any,                 sonoma:        "e03b0fbd145f6930ce815dc6886a43087d539b7a0c1158e5d65468bd28f7f0f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4e76466670c3dd1215899c5d76903df16596d6d22b9a8a7fe28f1f61e977fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa8ea2b5d8886eb4a1ee66ff5f971bd21abb2bf0c8138bf2ccdac46528487c1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "numpy"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/scipy/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from scipy import special
      print(special.exp10(3))
    PYTHON
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end
