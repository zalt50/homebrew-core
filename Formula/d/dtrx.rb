class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/57/b3/f47772c9476cdd7dbc469f871aee6ddd8a2617c7d90d62c5279c1e5694e3/dtrx-8.6.0.tar.gz"
  sha256 "94697941b640ffcd3c689895df8fb88e52ea98dec05dc181b9e996df761311a1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b821b88a4437f7a9350a8f05b9387aca29d73b305bba01fa1ae0033f032fdca0"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.14"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_path_exists testpath/f, "Text files should have been removed!"
    end

    system bin/"dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_path_exists testpath/f, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
