class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/29.0.2.tar.gz"
  sha256 "e2d0184acd2583c69ffab76a1b854146cc47f9980afb60679e171c3ebf132e5b"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-2.0-only", # wsrep
    { "GPL-2.0-only" => { with: "x11vnc-openssl-exception" } }, # galera
    { any_of: ["Unlicense", "MIT"] }, # uni-algo (our formula is too new)
  ]
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "0b1f7f89410aad22196d7d9a19a15d53320d801f42629b0cf21a4b1b98e554ef"
    sha256 arm64_sequoia: "ca3cbc138260c91c1e2c2860f924bf35d77ab500a88bea74fd8b464ae32a5750"
    sha256 arm64_sonoma:  "1df3563963ca485005c259e44dc18e05730680fcfc55152d36e7259b15ce4ecb"
    sha256 sonoma:        "862982ed9d3a09f7c9277e553146073978016b4fde80acdd55ebd20eca6e0fad"
    sha256 arm64_linux:   "b7345b19603ebe651896f9ab6c6c19f15a769f3fb0864ce19e0e9fc04531e40c"
    sha256 x86_64_linux:  "7967bd471876228349374c2aaec45dbd18cce69470a87704a8d2d70caa5eac83"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "snowball" => :build # for libstemmer.a

  # NOTE: `libpq`, `mariadb-connector-c`, `unixodbc` and `zstd` are dynamically loaded rather than linked
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@78"
  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "unixodbc"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "mcl" do
    url "https://github.com/manticoresoftware/columnar/archive/dbc40aa7a6955ddb33be3b1f777f74576f65a6a6.tar.gz"
    version "dbc40aa7a6955ddb33be3b1f777f74576f65a6a6"
    sha256 "8b3edb801951f1e7d1dc4ee7c0b9c3728dbc4626e927b91a745750db60791759"

    livecheck do
      url "https://api.github.com/repos/manticoresoftware/manticoresearch/contents/mcl?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  # Workarounds for building with Boost 1.89+ and GCC, until fixed upstream:
  # - galera: disable Boost (Boost.System stub removed in 1.89)
  #   Issue ref: https://github.com/manticoresoftware/manticoresearch/issues/3673
  # - searchdbuddy: include Boost.Process v1 environment header
  #   (`<boost/process.hpp>` now pulls Process v2 where `environment` is a namespace)
  # - sortergroup: drop redundant `using` that GCC rejects as private
  patch :DATA

  def install
    resource("mcl").stage buildpath/"mcl"

    # Avoid statically linking to boost
    inreplace "src/CMakeLists.txt", "set ( Boost_USE_STATIC_LIBS ON )", "set ( Boost_USE_STATIC_LIBS OFF )"

    ENV["ICU_ROOT"] = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                          .to_formula.opt_prefix.to_s
    ENV["OPENSSL_ROOT_DIR"] = formula_opt_prefix("openssl@3").to_s
    ENV["PostgreSQL_ROOT"] = formula_opt_prefix("libpq").to_s

    args = %W[
      -DDISTR_BUILD=homebrew
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_REQUIRE_FIND_PACKAGE_ICU=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_cctz=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_nlohmann_json=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_re2=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_stemmer=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_xxHash=ON
      -DMYSQL_CONFIG_EXECUTABLE=#{formula_opt_bin("mariadb-connector-c")}/mariadb_config
      -DRE2_LIBRARY=#{formula_opt_lib("re2")/shared_library("libre2")}
      -DWITH_ICU_FORCE_STATIC=OFF
      -DWITH_RE2_FORCE_STATIC=OFF
      -DWITH_STEMMER_FORCE_STATIC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath
  end

  service do
    run [opt_bin/"searchd", "--config", etc/"manticoresearch/manticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = spawn(bin/"searchd")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end

__END__
diff --git a/cmake/galera-imported.cmake.in b/cmake/galera-imported.cmake.in
index 0ffa9caf1..806c929b4 100644
--- a/cmake/galera-imported.cmake.in
+++ b/cmake/galera-imported.cmake.in
@@ -15,9 +15,9 @@ include ( ExternalProject )
 ExternalProject_Add ( galera_populate
 		URL @GALERA_PLACE@
 		URL_MD5 @GALERA_SRC_MD5@
-		CMAKE_CACHE_ARGS -DWSREP_PATH:STRING=${wsrep_populate_SOURCE_DIR} -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DGALERA_REV:STRING=@GALERA_REV@
+		CMAKE_CACHE_ARGS -DWSREP_PATH:STRING=${wsrep_populate_SOURCE_DIR} -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DGALERA_REV:STRING=@GALERA_REV@ -DWITH_BOOST:BOOL=OFF -DCMAKE_CXX_FLAGS:STRING=-DASIO_DISABLE_BOOST_REGEX=1\ -DBOOST_DATE_TIME_POSIX_TIME_STD_CONFIG=1
 		BUILD_COMMAND "@CMAKE_COMMAND@" --build . --config RelWithDebInfo
 		INSTALL_COMMAND "@CMAKE_COMMAND@" --install . --config RelWithDebInfo --prefix "@GALERA_BUILD@"
 		)
 
-# file configured from cmake/galera-imported.cmake.in
\ No newline at end of file
+# file configured from cmake/galera-imported.cmake.in
diff --git a/src/searchdbuddy.cpp b/src/searchdbuddy.cpp
index 39985f6..9c83062 100644
--- a/src/searchdbuddy.cpp
+++ b/src/searchdbuddy.cpp
@@ -24,6 +24,7 @@
 #include <boost/process/v1/error.hpp>
 #include <boost/process/v1/handles.hpp>
 #include <boost/process/v1/io.hpp>
+#include <boost/process/v1/env.hpp>
 #else
 #include <boost/process.hpp>
 #endif
diff --git a/src/sortergroup.cpp b/src/sortergroup.cpp
index 13c4feb..d1f91ad 100644
--- a/src/sortergroup.cpp
+++ b/src/sortergroup.cpp
@@ -347,7 +347,6 @@ protected:
 	using BaseGroupSorter_c::AggrSetup;
 	using BaseGroupSorter_c::AggrUpdate;
 	using BaseGroupSorter_c::AggrUngroup;
-	using BaseGroupSorter_c::AggrDiscard;
 
 	using CSphMatchQueueTraits::m_iSize;
 	using CSphMatchQueueTraits::m_dData;
