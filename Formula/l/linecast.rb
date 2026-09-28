class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/7b/4c/234993054f4230a9710de7d12aca1fcae9a30189bafd772076e8b49f4209/linecast-2.9.0.tar.gz"
  sha256 "8d16a1ed358e2e84e443c3eca27fa8bc7c7d210f7751faae5d4ddcc15db3e772"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87c385f3048f97b2d6fa9cf87f1efdb143e5aa44837667cd73cf558ba2b16e24"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end
