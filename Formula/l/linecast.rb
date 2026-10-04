class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/da/c9/e240a287086ca30c1f149581f924b1a881aa8886c3ee2bd6b3a68a189ea4/linecast-2.10.0.tar.gz"
  sha256 "74fe8dc1b96418f98f392da113378fc5ac43e4e4d92c2f22bdff513eb63727e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf274a852c1d72f6c9c1177430a4533319ccc4c1748aaec735fde1c35e7f0b34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf274a852c1d72f6c9c1177430a4533319ccc4c1748aaec735fde1c35e7f0b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf274a852c1d72f6c9c1177430a4533319ccc4c1748aaec735fde1c35e7f0b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1997fe06e1b0bbf8f9446b04ac3ef5ff956ae65ad2834dfea3f62d4d73ea1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e1997fe06e1b0bbf8f9446b04ac3ef5ff956ae65ad2834dfea3f62d4d73ea1db"
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
