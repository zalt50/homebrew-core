class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.5.0.tar.gz"
  sha256 "57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4b98687e9e97e4f963a258390d968f775777332c3274dffe1f919f158dd7e2a"
    sha256 cellar: :any,                 arm64_sequoia: "9279ae3479091e3228c233f390e696ba3e7bbcaba8e9e15311cdc862fe7bbd12"
    sha256 cellar: :any,                 arm64_sonoma:  "e93d3935a8bc573858690650ac13f1aced0098a523bb7071dc359d556afd9100"
    sha256 cellar: :any,                 arm64_ventura: "0b3992a9aabd0ccb38e6edcac9188a67343992058e3b72921f81c2eb0c3ffc49"
    sha256 cellar: :any,                 sonoma:        "c8816a8327ee6a27121fa5a955fcfbac1788474f0d72a8c75876170dc455b497"
    sha256 cellar: :any,                 ventura:       "e8e982877166d4a0b87e50a3aeae7613b98f0b596da2a292353f1df1a2e1be8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ca1da210601500a01485460ff6c6a7ebc2c4c396ac0d376b25295308ccf1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4edfa03fd344d303def0992a7e02fe5e614c3e9c256e44b84348bb0fe108a13"
  end

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/cd752b79c8dc7106cef6c95404308c1b1c400770/Patches/lua/lua-shared.patch"
    sha256 "7774de7be06126805f189d321bcee595a676858c52d26f6777c79f5c1d789975"
  end

  def install
    # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
    # when making a shared object; recompile with -fPIC
    # See https://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID) from our patch
    inreplace "src/Makefile", "@OPT_LIB@", opt_lib if OS.mac?

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    args = %W[
      CC=#{ENV.cc}
      INSTALL_INC=#{include}/lua
      INSTALL_MAN=#{man1}
      INSTALL_TOP=#{prefix}
      MYCFLAGS=#{ENV.cflags}
      MYLDFLAGS=#{ENV.ldflags}
      PLAT=#{OS.mac? ? "macosx" : "linux"}
    ]

    system "make", *args
    system "make", "install", *args
    lib.install Dir[shared_library("src/liblua", "*")]

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %w[-llua -lm]
    libs << "-ldl" if OS.linux?
    (lib/"pkgconfig/lua.pc").write <<~EOS
      V=#{version.major_minor}
      R=#{version}

      prefix=#{versioned_formula? ? opt_prefix : HOMEBREW_PREFIX}
      INSTALL_BIN=${prefix}/bin
      INSTALL_INC=${prefix}/include/lua
      INSTALL_LIB=${prefix}/lib
      INSTALL_MAN=${prefix}/share/man/man1
      INSTALL_LMOD=${prefix}/share/lua/${V}
      INSTALL_CMOD=${prefix}/lib/lua/${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/lua

      Name: Lua
      Description: An Extensible Extension Language
      Version: #{version}
      Requires:
      Libs: -L${libdir} #{libs.join(" ")}
      Cflags: -I${includedir}
    EOS

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install_symlink shared_library("liblua", version.major_minor.to_s) => shared_library("liblua#{version.major_minor}")
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    assert_match "Homebrew is awesome!", shell_output("#{bin}/lua -e \"print ('Homebrew is awesome!')\"")
  end
end
