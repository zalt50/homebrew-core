class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/30/11/5b6c9ce24c1b23effa0db201babf7610f15a98ecf6a7c3a00fa68db7a1fe/texttest-4.4.7.tar.gz"
  sha256 "448d7f2d5c2883841df421d84b325b90067c0d385c4d6a700a6fd1cbe0972318"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436a8ff3d8efc9ce3572fa6c92a2c8fe10a0988a66fca562f9df1e2d19ac0be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9704e045db66ccbb3ba47e19e3bd6e42a1a0bb172b29d56d0c0156124fbeb2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d492f3eac297e328f7568feaeb0a1c12352abff053315dd34978edc9b9d4d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "282d47d8bcc5d9df1319d15fc4ac3cd70853fe26fdecc85614083d7b41742527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9112d710cf89b3dd3c43e6e44e4a81cdfeb52fe320775faa3b27dd3ba188e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73ee0045cb722f2d9e007b980f539caeca17e5d83ab87cfeb5a6d7e8fbfdaa8"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
