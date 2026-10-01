class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.22/Python-3.10.22.tgz"
  sha256 "9448b34d16f8e3db0964ac3ed9fb283197747543c2c021f283ffd2c8b7287357"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "31c864912ccc6276b811ce314e75f6498a873325f05da80db84c80986811bfe1"
    sha256 cellar: :any, arm64_tahoe:       "41c68aa8e1fbb5b13c9d71acca7d1ecc1b1faa337abf982523f7862852f35454"
    sha256 cellar: :any, arm64_sequoia:     "72c0c510440474eb62ab562ec31c59c120b71767c5df969a175536c89cb778e0"
    sha256 cellar: :any, arm64_linux:       "b3b4d9ef4b8ec5bda4c8bda9ed6a5a5409c692231607b4aa09a2fbd50bc09ffc"
    sha256 cellar: :any, x86_64_linux:      "1338cd7f6cb4073b8b91fe56450ad5c447b7e0141d9744f1c3359fc9d7799b9f"
  end

  keg_only :versioned_formula

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2026-10-15", because: :deprecated_upstream
  disable! date: "2027-10-15", because: :deprecated_upstream

  depends_on "python@3.10"
  depends_on "tcl-tk@8"

  def install
    cd "Modules" do
      tcltk = Formula["tcl-tk@8"]
      tcltk_version = tcltk.any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{tcltk.opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{tcltk.opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"
  end
end
