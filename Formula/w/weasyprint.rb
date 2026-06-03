class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/59/53/dcc3885c2f7a47faa45f6b8b801412f5f9e055173a52801ef01c09943c5a/weasyprint-69.0.tar.gz"
  sha256 "a7a32f39ca16bd82ef11de99c92ea4b5f14951c9033af035e451ce4f4ee0a88c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "964785f9c83bb3d485af26c6d2f8fd8ffaf2ebfcd59f2bd1182459278fd7c4dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac8612895015377306da0b821f46baffad8ecb2b0080eceaa6b072a21610fbf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2581319133b9e1282c1322694c6ac8797c689514c6dea7e918e6951fec03ad31"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc0a758c4587e3585f5981dc08d99083b623b727b165031a128c7e60bf842779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec5a3c8494720363e9b8fed28802cd5fd71608a67fe6037717e11a2081a7888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba97d7603ffa48d3a9b7eeb4f533b1d3dfdefbd216f754dd9329636c4d19ede9"
  end

  depends_on "cffi" => :no_linkage
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[cffi pillow]

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e0/20/92eaa6b0aec7189fa4b75c890640e076e9e793095721db69c5c81142c2e1/cssselect2-0.9.0.tar.gz"
    sha256 "759aa22c216326356f65e62e791d66160a0f9c91d1424e8d8adc5e74dddfc6fb"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/84/69/c97f2c18e0db87d2c7b15da1974dace76ae938f1cfa22e2727a648b7ed43/fonttools-4.63.0.tar.gz"
    sha256 "caeb583deeb5168e694b65cda8b4ee62abedfa66cf88488734466f2366b9c4e0"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/36/ee/fb410c5c854b6a081a49077912a9765aeffd8e07cbb0663cfda310b01fb4/pydyf-0.12.1.tar.gz"
    sha256 "fbd7e759541ac725c29c506612003de393249b94310ea78ae44cb1d04b220095"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/69/56/e4d7e1bd70d997713649c5ce530b2d15a5fc2245a74ca820fc2d51d89d4d/pyphen-0.17.2.tar.gz"
    sha256 "f60647a9c9b30ec6c59910097af82bc5dd2d36576b918e44148d8b07ef3b4aa3"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "tinyhtml5" do
    url "https://files.pythonhosted.org/packages/b1/1f/cfe2f6b30557c92b3f31d41707e09cef5c1efbd87392bc6c0430c46b0e4d/tinyhtml5-2.1.0.tar.gz"
    sha256 "60a50ec3d938a37e491efa01af895853060943dcebb5627de5b10d188b338a67"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/05/4d/b5a8c14cfc7beb5dd798f316418126b5107a54d5f9ba322ad874089b91ce/zopfli-0.4.2.tar.gz"
    sha256 "a75e646fed3a2a42a82e69a81644009189c8ab4271691f020d52da8630d0580e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.html").write <<~HTML
      <p>This is a PDF</p>
    HTML
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_path_exists testpath/"example.pdf"
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
