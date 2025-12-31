class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.99.6.tar.gz"
  sha256 "5839921a0f67d7d8fa3dacd9cd41e44c89ccb867e8a6db216d62628c7fd14b09"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/tcpdump.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?tcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cecfbd8582f8567f44e64be800a4c1485f1194d5e18e149604b30a460eddbbe8"
    sha256 cellar: :any,                 arm64_sequoia: "8fe09be0df83c85a118ff5c5e0d9e5f226ccbea68cbd15ff58e9881a87da539d"
    sha256 cellar: :any,                 arm64_sonoma:  "0db0ad3d88b277b82f4856514b59f9625daba8c1274034709ede5e21c5d0758e"
    sha256 cellar: :any,                 sonoma:        "8272a3c5993d0fef9408ed6314d9496517a46552f9a50b4d64ac3ccb58192283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7859a1f33a16e401345553367d69aec1b0344cb0bcdcb8e5688adeb5e64007ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41f3c3553e2199b6f215599e4cb7772981947a4d9f19703ce2d91c5ab9e081a"
  end

  depends_on "libpcap"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tcpdump --help 2>&1")
    assert_match "tcpdump version #{version}", output
    assert_match "libpcap version #{Formula["libpcap"].version}", output
    assert_match "OpenSSL #{Formula["openssl@3"].version}", output

    match = if OS.mac?
      "tcpdump: en0: (cannot open BPF device) /dev/bpf0: Operation not permitted"
    else
      <<~EOS
        tcpdump: eth0: You don't have permission to perform this capture on that device
        (socket: Operation not permitted)
      EOS
    end
    assert_match match, shell_output("#{bin}/tcpdump ipv6 2>&1", 1)
  end
end
