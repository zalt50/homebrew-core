class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.224.tar.gz"
  sha256 "a6d22bb95c5f07d5b44c8ad67a9fb200c251261e174c41bcc8aefdb147fc1a86"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "db541b717f4ee797436e10b269456c307532f607d987da6eb69ee7a2418100cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d6a09ac73e148d42be622a25f778f77ffeda238741191916ea2cfbb29980c76b"
  end

  keg_only :versioned_formula

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
