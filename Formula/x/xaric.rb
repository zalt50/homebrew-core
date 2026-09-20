class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.10.tar.gz"
  sha256 "8f270165f3b12cffb5bacf2dcdd507e2939bd4815936cf670a1fb68142b341b0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xaric.org/software/xaric/releases/"
    regex(/href=.*?xaric[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "03f5073bc47f49350ad66c61a7f6072aa93150917006c078a92f15c03066026d"
    sha256 arm64_tahoe:       "28872c99390c2300d6378440d8e060f769ab078e46c9e94a71890b0889d0a409"
    sha256 arm64_sequoia:     "97f67bb569cb2956953e6b36fda5652e6102304962f9342bab5328d9e16a73ad"
    sha256 arm64_sonoma:      "f85f7887576b2b971caab0247fc1e9dd7dc0c8ff3bd9df731564ae9a5cc3f7cf"
    sha256 sonoma:            "01c3409aaf6f70234eb46227f93011a4304a5d0db483cc93699ed67b8314f1e1"
    sha256 arm64_linux:       "4e5a4883340539ac88a7ab2fc160d92eaf49af6abef2fca8dd217e65d30afb90"
    sha256 x86_64_linux:      "79f59d62efb2fe4cccee741c6a50431596985b700547d2ef333545ec087237ef"
  end

  depends_on "openssl@4"

  uses_from_macos "ncurses"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn(bin/"xaric", "-v") do |r, _w, _pid|
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Xaric #{version}", output
  end
end
