class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ba1f34d9b0ea8d6e49e5ed4e459640eb0889c2ea8bd37fed8def5eb0be8b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "55dbc5b431725a5be9f9da921bb903db6ace6f7945db3d007956d94797c1f68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333d94af5b6c4482a7778980ffa4b0f5b7b9e0ea45b6f304067a249b17ed2bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "333d94af5b6c4482a7778980ffa4b0f5b7b9e0ea45b6f304067a249b17ed2bc2"
  end

  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

  # `flit-core` builds `packaging`; keep it first so it is staged before it
  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  # Backport switch from removed `pkg_resources` to `packaging`
  patch do
    file "Patches/fades/drop-pkg_resources.patch"
    type :backport
    resolves "https://github.com/PyAr/fades/pull/432"
  end

  def install
    ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
      end
    end
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    (bin/"fades").write_env_script(libexec/"bin/fades", PYTHONPATH: ENV["PYTHONPATH"])

    man1.install buildpath/"man/fades.1"
    rm(libexec/"bin/fades.cmd") # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
