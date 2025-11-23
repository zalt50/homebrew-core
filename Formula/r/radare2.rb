class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.0.6.tar.gz"
  sha256 "a06a6aaa20264276d25b78fd8ff293c9b13afcd6fb1fc110185ee37237441aa1"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e36aab50de34e2f4b0cae686c90ef05f2c5f033291f824de2b49ae7735217cd7"
    sha256 arm64_sequoia: "9aa7e019b1a0737b441763b6830f829a1e81209da8e34f60e1ef32cc4d3db149"
    sha256 arm64_sonoma:  "1f8e790bb60cf3e5a0579100274e2b818d2dfeaeb7e47e9f3248cc01c52956c9"
    sha256 sonoma:        "23f6a8b89b846286ba7f4f7c988b6f9a10bd18c58dbe2411d2b41189ced55129"
    sha256 arm64_linux:   "4226d77bcdf979717a35c12d6698c765e4ca60ce2554b9fcadbe539874fbfe89"
    sha256 x86_64_linux:  "db9096a1f1104f488caaf566132a00c88f55388ed4d9dedff4c71c798748d395"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
