class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/1.53.0-0.tar.gz"
  sha256 "bd393b5918f320c79a2c6405e3abebe01c024557c32b9fb9006bee20ce71e19e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a0cdfce58889e1726c4f4809fde4e8c3d0dc2fdabe95fb8f24aa2cfb34cdb3b2"
    sha256 cellar: :any,                 arm64_tahoe:       "749819a8255ec6cb1ae287fc3aba617eb990301df4dc89211ce0d8b639f62c0e"
    sha256 cellar: :any,                 arm64_sequoia:     "bcd21234139140236ad2a94c0dc28f78b5f810a4d96fd799dc85cc1499a22390"
    sha256 cellar: :any,                 arm64_sonoma:      "8b863c574a8daaf828c99dbbf1ac8e67d543122ea9c2154c20770ef70ec13117"
    sha256 cellar: :any,                 sonoma:            "a643e41957c33342174f7cf205d47b3c1ed10d433b423823f87414cd4eb4d807"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa89efaaf09f951f575767cb079b4da38566e39af1b94fdeee0b9c81b13dc6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ece75e8ec4e4de53025c4a2047ad3768e73a6aaa1fb093796158b69db1a9d82c"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.15.1.tar.gz"
    sha256 "16c4bd7b72a156e3b575ce2b5ebe2ec00611a14c485dd15dc3814647a589c7f8"
  end

  deny_network_access!

  def lua
    Formula["lua"]
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" if build.stable?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    # https://github.com/luvit/luv/issues/787#issuecomment-4041758224
                    "-DMODULE_INSTALL_LIB_DIR=#{lib}/lua/#{lua.version.major_minor}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("#{lua.bin}/lua test.lua")
  end
end
