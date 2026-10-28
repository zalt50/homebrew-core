class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.44.0.tar.gz"
  sha256 "ca982a56617f085f350934c90606a79e149d8ff547c4821deacbca01592f4806"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "40ba6b8f1ef8e4b24de0193c887240a6306549d3ad35438e1c5381ba393ba553"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end
