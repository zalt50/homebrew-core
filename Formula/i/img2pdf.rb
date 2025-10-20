class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/82/c3/023387e00682dc1b46bd719ec19c4c9206dc8eb182dfd02bc62c5b9320a2/img2pdf-0.6.1.tar.gz"
  sha256 "306e279eb832bc159d7d6294b697a9fbd11b4be1f799b14b3b2174fb506af289"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed1ea4bf5f39436b4033690c4b33ba58b645e1c4143b11d8725fd4ed1da5dcc2"
    sha256 cellar: :any,                 arm64_sequoia: "1079b3b50de55ff2cb1ddba4de0b6263eb02e19e4b8c71b789a6e06c5a6eb592"
    sha256 cellar: :any,                 arm64_sonoma:  "3de734f6984a7b7e9642891724dabaa3f21d61627c82d06a5d43828eaaf2933e"
    sha256 cellar: :any,                 arm64_ventura: "e43e023adc6d723aeba2a655fe2aa389ed431132cad290adf7a9fe40e361879c"
    sha256 cellar: :any,                 sonoma:        "a23983ca26c2f1334d67ab269a3710623e3ccf836e05fe29709275a1bb69221b"
    sha256 cellar: :any,                 ventura:       "baf5c53f44485b93ba85f1ca2da11ad6afb6537ccf810e768ca539e9d9e55fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5420086a7f5c69c6afdc715b30a04b2956e4bb62ebc50c32f3080e7057e8444a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ef1ecb337f847a0348943032ef9432b5b5c012ae95c45fb6182fefa6e8dfa4"
  end

  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/f5/4c/62b37a3ee301c245be6ad269ca771c2c5298bf049366e1094cfdf80d850c/pikepdf-9.11.0.tar.gz"
    sha256 "5ad6bffba08849c21eee273ba0b6fcd4b6a9cff81bcbca6988f87a765ba62163"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
