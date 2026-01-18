class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.31.tar.gz"
  sha256 "00dc6d26c8de5d515f42c7db2d29ce5e42d34abc0164aa7b01905a226865955c"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d81b6011cb52be1a0f6e3b21e7c8e8883def5b63c435cb2eda790a7114dc1ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "410bcc53e8d94a71d6469bc4afb68f43e7d8604d1dfb54cb6d391c3a09a92557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e17176fef824ce58a3bfd5386fd763f0fcc9a3ef1d6d625378531e13eca786d"
    sha256 cellar: :any_skip_relocation, sonoma:        "159cb9447c7d9846dc14c4a6a5416b7573c1e46315e55e80e55f4fdad8872a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b15631ead8128b1b239a2e9f6999285ca64e1c7e85818b37de61703fbaafb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c225e9ba6d22b283fc8884414b4a452330bd393701cecbcb96dda23247c1987e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
