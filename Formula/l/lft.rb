class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.99.tar.gz"
  sha256 "f34707b543391eb887ba8479f7d2c2670bfefc3afb244dc5d34a2a41d7b317eb"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ba17be6362157133e65a17b1f2d0216f2e5502e48af943b324583ea696b8a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362b211ae4a1a8fec0bb127667355871fe6ee2f9b669cfe3672f9a040f4af2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172e828c28d5ff5b7b0058c86ecd5009fa090170737eabf0b716555c1daf8dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5de7a22f2afa631c3f46b47252eeb80753f5b70348c80bca8ba85d43c87e5a00"
    sha256 cellar: :any,                 arm64_linux:   "ef6f383d4689cf6f2ef05c3eeb4c30e3dba3744ecf570b6dcd61db84911163f5"
    sha256 cellar: :any,                 x86_64_linux:  "81fe8bb11d1638551327990c7e51d8248ba6c18e665c95a2ee043208f0c5b4d0"
  end

  uses_from_macos "libpcap"

  def install
    args = %w[
      --disable-async-dns
      --disable-ncurses
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
