class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.1.0.tar.gz"
  sha256 "21b4e68fd956e5691c8d5274a32367b13e389d2c8080115764c9c30a5f7f6008"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93cd18e30f7d6d7c4092d0cee410ff771caa32e198aa55231a8f4ee978037373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eaf586b84ca28f550599d15e1d585ab43282d212f7cb1ea174b6fca5c56c8aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ace0372e7497272c80028b4b7e67ef09ebedc336a9d6f114f028c0f24fa93ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5eb80daf46a4f90a317fd9a8c9337cc2b62fd933fa279fd47f9c8b2067f0bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86aed919e6ba72a10fa52bde00cf9308e15eb1e0765b44a331ed4733848cb655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6664d45d269b8bd6e3cdace9b09af43f5052f34129c422639b485d54713820"
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
