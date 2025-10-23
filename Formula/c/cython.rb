class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/e3/58/6a8321cc0791876dc2509d7a22fc75535a1a7aa770b3496772f58b0a53a4/cython-3.1.6.tar.gz"
  sha256 "ff4ccffcf98f30ab5723fc45a39c0548a3f6ab14f01d73930c5bfaea455ff01c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1d0433e15347faa5633bac2947c36d69694f3d346d86950e4eac377d4ae69dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec238c68606fb28c3e8374fa8674322b443a295e6597c3f66491bab1f974ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f3addf9990a4fe621d3c1a207f3b01da6d9f9e51b8e614d2155982aae7e2b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a256aa9cc9d525dd9727149f8e6787bbedc7f09b417f524e9463e3e0ba5d2e84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33abe3f7a358fa21824772d22fc55c41f7837eb5e421d1c1d7e649bfb816506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba9b4c8fe5a31576658f6e3e5b30423a523956ee962602afe3b6b510d2da845"
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
