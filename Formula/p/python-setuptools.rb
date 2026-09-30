class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
  sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29182943b6f0fa24b435189df6b04b373e43c39039cc15b380491f4299437ad4"
  end

  depends_on "python@3.14" => [:build, :test]

  deny_network_access!

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Pure python setuptools installation can be used on different Python versions
    # Add symlinks to use on all externally-managed pythons
    extra_pythons = Keg.for(python3).to_formula.versioned_formulae.select { |f| f.version >= "3.12" }
    extra_site_packages_list = extra_pythons.map { |f| lib/"python#{f.version.major_minor}/site-packages" }
    extra_site_packages_list << (lib/"python#{Formula["python-freethreading"].version.major_minor}t/site-packages")
    site_packages = prefix/Language::Python.site_packages(python3)
    site_packages.find.select(&:file?).each do |path|
      extra_site_packages_list.each do |extra_site_packages|
        (extra_site_packages/path.relative_path_from(site_packages)).dirname.install_symlink path
      end
    end

    # Ensure uniform bottles
    setuptools_site_packages = site_packages/"setuptools"
    inreplace_files = %W[
      #{setuptools_site_packages}/_distutils/compilers/C/unix.py
      #{setuptools_site_packages}/_vendor/platformdirs/unix.py
    ] + setuptools_site_packages.glob("_vendor/platformdirs-*dist-info/METADATA")
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system python3, "-c", "import setuptools"
  end
end
