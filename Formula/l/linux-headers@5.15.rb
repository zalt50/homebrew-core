class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.202.tar.gz"
  sha256 "7459799f7138c67817f587225d453647b2219f5371d0b610823a5fcecbc496d8"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a65db1994a3409cdba912aca13cb189691b121fef32bd3cb03d94fe213e9debd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "528bac4029f5f7aaf2e101d880df0de6b33d817c963af7e14c950bd2c8673bf4"
  end

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
