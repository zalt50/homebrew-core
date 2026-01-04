class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/91/85/7574c9cd44b69a27210444b6650f6477f56c75fee1b70d7672d3e4166167/cython-3.2.4.tar.gz"
  sha256 "84226ecd313b233da27dc2eb3601b4f222b8209c3a7216d8733b031da1dc64e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0f6b81f2e97c5285de1a912e893aa1479853ff2535c6e66233321ffc0c13d70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59544556451d741f852cbeb45da74649c5afc258595e6a9c6ff97910b8bdf411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4fab1a942968b0d2974a47539b029b5e1a4c95223be8d09602f3e094cf82cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4bde0ef9e895276aac4b09c4522f3e12c8ee805fac020360aa2df8a4795269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a3f479f97dfdefcd030311af48c35bfaa6a46228db5f40d8248dd008c2851cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6110b3581a5e3d407dda0bc3700c5d276a3f2c8d26f9e52d5739b0af909970a9"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
