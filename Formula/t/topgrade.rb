class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.1.2.tar.gz"
  sha256 "58d1d8de281dbcb4fd2cee1e1e8b22deb5e5baf282c9518a3ddb2673bba07c88"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d40cf5766e03976879e8d895a5ab0e70008186d90e81cd19bac9eb5baf73970b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a48792e6f2daa67dc43a456e98a44a200950531d1ca15ec6c5d1d8078bc743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65b35781852af5a695687b07300526c89848a41fbc4543aab470f0d647c27dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3318cf6721ade4975f4b4cb8009ad4a54e028f9cd276502bc4dece5b44582009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e471fd67b7cb5a8d60f7f2e5214f8b481559052761a5ef8852d2014a6f0e64fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7450f730d7355498595f6afc85f01ce2ed84e4f935788f2c75a380963cef9f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
