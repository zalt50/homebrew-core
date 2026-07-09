class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.12.2.tar.gz"
  sha256 "e1f8ae6eaa60a07dd83a50a0d5b24743790e6b228dba55b70986ce2b56b013b9"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9f01841b4a940ecc87541656d419b285155d2dffc3e8a1ed845a845ec376a5e7"
    sha256 arm64_sequoia: "aef201fcbbb33ee0d48d9ad8a4f8fc9eb54116f3b3f264d9d7782770f1628d7c"
    sha256 arm64_sonoma:  "b049518dea22f0430b667aa20832f430787fd5ef5b3f94b07a6458f525f8fbae"
    sha256 sonoma:        "fd56f8179069541d59f3f65eaaf24964f4f94fa53e2bc69568b219d557669d9f"
    sha256 arm64_linux:   "edef0183060f45e20ccf33095b2c64533f8e0c166ac9a0015660b8493effa279"
    sha256 x86_64_linux:  "03172e7465af281f6cbcba83fa9faeca6f9c31fd148266c5a17a9978b39fd29c"
  end

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
