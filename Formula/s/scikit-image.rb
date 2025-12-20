class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/a1/b4/2528bb43c67d48053a7a649a9666432dc307d66ba02e3a6d5c40f46655df/scikit_image-0.26.0.tar.gz"
  sha256 "f5f970ab04efad85c24714321fcc91613fcb64ef2a892a13167df2f3e59199fa"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27da6cc33d77c6a785a9c8ea4df0d2f7edfa03dc24085a1608edcef43b13044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddce8132980d3b4e3f94babf269f076f136b309401de1877c3b3689a1b016557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f357f344cc9bcf5d1a75190aca51d004e003a2a70f320cdb4d7f1147db7201f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "654d5b525c02f6b0f6bcfa442b3f58125e2cac12875a9335aee531b6e108a710"
    sha256                               arm64_linux:   "0b04fcd70cba257b24cbf944e8e95013c5744e4367547e8eac93e040b18484ae"
    sha256                               x86_64_linux:  "24372313c3590ffa120fa37bbc6b8f9da8cec269511c25f57fdf99635988f2b4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[numpy pillow scipy]

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/a3/6f/606be632e37bf8d05b253e8626c2291d74c691ddc7bcdf7d6aaf33b32f6a/imageio-2.37.2.tar.gz"
    sha256 "0212ef2727ac9caa5ca4b2c75ae89454312f440a756fcfc8ef1993e718f50f8a"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/31/b9/4253513a66f0a836ec3a5104266cf73f7812bfbbcda9d87d8c0e93b28293/tifffile-2025.12.12.tar.gz"
    sha256 "97e11fd6b1d8dc971896a098c841d9cd4e6eb958ac040dd6fb8b332c3f7288b6"
  end

  def install
    virtualenv_install_with_resources
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/skimage/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    PYTHON
    shell_output("#{libexec}/bin/python test.py")
  end
end
