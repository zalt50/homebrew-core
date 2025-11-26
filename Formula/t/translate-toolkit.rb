class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c0/7a/f3e022443bf110271a5a63e538da9f00dff381a0e81f0feff380ab8f09d8/translate_toolkit-3.17.0.tar.gz"
  sha256 "c842ce7f0d8ea92feec849f33328963121fc3896ba6fe382fd77d99d650d2f77"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96a96d4a98ba14fe4c670f710cce962bef382da36acb65eefd7a09f71397f328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4cd31c801f53c68816fe9f2b7c40c66f942a8c66e4728128803d912acda291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b125b5a074068a4c5c38c8a35008abe0d8c68beb9d572b6accfab3deef9df312"
    sha256 cellar: :any_skip_relocation, sonoma:        "67ac860a8fbf6f7efd8ef77f334cb2a6b4ec81117d9029112bcb6bf2bdab5202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73a8ee3759931c5265267e7c44f4e990851f68f89ba328971b90e704cbac12bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863c7d1b12c6e839affa45af8bbe492ebc79233864d920b322b11643c7f0c776"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "uniseg" do
    url "https://files.pythonhosted.org/packages/26/9e/179eab698c565904a25bf0d8c999ef7ec858c9828809df2d1a5b92a5dd67/uniseg-0.10.0.tar.gz"
    sha256 "b5ea258b3a21bfe9ce1adde56836c0d055743a69aba44cb9d3596bda4f0c52a3"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
