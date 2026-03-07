class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.2.tar.xz"
  sha256 "7e2f619d4dcd28d9d86864763581a1b453499f8dd0652af863b54045a8964d6c"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "99788b968d8ed34a7e838c581ab007bb4f529823b658ae2066d87e8caf821762"
    sha256 arm64_sequoia: "594073d5720ca68dc70203b2834416d69eb7d5df832468fcf263fdae5cadd4ad"
    sha256 arm64_sonoma:  "ac357c9a58fcfd30f6515f9c4e2b0672e206cceedbfd52a787dbf389ab0988c5"
    sha256 sonoma:        "e25a86e6241ea83314cddd5e8bd10720b5f62223934225610ac4e5c69f7fcd00"
    sha256 arm64_linux:   "1ac15d724e05ccc01e74e31e6d4ed01232d9cc15d01ac619ba7f4338732325aa"
    sha256 x86_64_linux:  "5e73c4c6f46f4494509af0cef7cc019b818bc0f582086120a747c7407f84051d"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "python@3.14"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      -DENABLE_GUILE=OFF
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_MAN=ON
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    # Help CMake find Perl header on macOS due to non-standard layout
    if OS.mac?
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path}/#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end
