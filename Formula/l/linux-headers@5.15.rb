class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.210.tar.gz"
  sha256 "0ce029c0f22637de26a2382cdd76e22c9dcfa7704788b8be42ff0812ff62fab9"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a5df93d9f09bcaa52f90877a14ded22beafa4d8defd2904f14f9f2ccc76c8fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "59d973cca8c9fdc34185350ae907ae4b7501b4759832011b0cbfd4c6bf12b66e"
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
