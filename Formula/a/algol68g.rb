class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.13.1.tar.gz"
  sha256 "45c57989a576c733ccbf9ba0057978563a7d2a485324eddab3ad2a5e1fca3ba2"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b5c1fe9e347008bc3fb73743001835c575c8521cffa9521130520f4cf30a4e25"
    sha256 arm64_sequoia: "3d93f8cccc2f9a4c4fc91c7bad9ad75ea4da5545ebc7a897c74cacfb83121e3d"
    sha256 arm64_sonoma:  "052a6d91d2cc10023d59cf7959097e9e05b4eb21286c8fd7d271f74d1e247dd0"
    sha256 sonoma:        "9b711769b98b9e83686f7c528b55daf1b9b6620c7cc0b0a311db80f2eb5c784d"
    sha256 arm64_linux:   "9a3f52c6ead6712e53967979dcd46b8541ebc28c338eb33d48b553cafa97bc86"
    sha256 x86_64_linux:  "12293ce7b511be4d9343502b323004c9778f80c56e8d941e82fa3b9b372ab974"
  end

  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", *std_configure_args
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
