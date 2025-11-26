class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "24edf6a6afd349e92c5cdf62324e783be822db24b1402024f2ff38ddfac7b25b"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf5661cdabe0b0cc21e3268cf2a692c39f174c0d5417cbc907fc5f90c5b8bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74adeb3d1cc9c6fb4aea356978f322e9d96c427a3608eba030d034b0472a9d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb2bfaf815dc6d70ce50d1f5dd4da7e98b62231d3bc68e4273297ef655baf7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b86d2d14143d3a86d8e2ad83defbbea1e846849c82ad6c0777d337fe06bd00e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f731b9eb0bb16593a8433c36e6ae8e93095877b7f697e5e6b190c734758c1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5105fa5b187eeae8ca93ab0a3c2f12a49bc1887b2190fcecef63f3f642b22c9d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
