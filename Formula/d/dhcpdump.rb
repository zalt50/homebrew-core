class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://github.com/dhcpdump-org/dhcpdump"
  url "https://github.com/dhcpdump-org/dhcpdump/releases/download/v2.00/dhcpdump-2.00.tar.xz"
  sha256 "41c79aa975662f33b1b7acaa0ab4c071b654cc78166c6475e82e3f0cfbe4b009"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39614d4823ce76fbc86945ccc49f928fafe40feb69db968be35e344277e56238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64423f71b7329c84e68c15c5bcfafffd2320c1e162217fcc64708f2fed3a8c5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c3d73c5be91e2e18e83f167978b9df24a909967ddc428e22377a969e8a2cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a003cda0caa278f470e4372026370677e51d0fbd7fe480007b63057704e0b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db8fb7e6d259eafa1889dab5548fa25fa4daf47518d4e3eb9eefe7dce61d93b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "088e0cfb92a8985ce563e6ec7c95df6eb39c3f7b1a18acd45464ec136a161cbd"
  end

  uses_from_macos "libpcap"

  def install
    # the interactive TUI (-t) needs yascreen, which isn't packaged
    system "make", "NO_TUI=1"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    # live capture needs root; this capture holds no DHCP traffic, so nothing is printed
    assert_empty shell_output("#{bin}/dhcpdump -r #{test_fixtures("test.pcap")} 2>&1")
  end
end
