class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.2.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.2.0.tar.bz2"
  sha256 "bef171a7d064794e05ec7559e46d3e07c3ae6487a4647987fcc4f1cc5a82cec6"
  license "Apache-2.0"
  head "https://github.com/apache/trafficserver.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "7787222bc5925d56fa17ac3ab2a516ca51d9fb9a7db3d7d08047c558fa8c3735"
    sha256 arm64_sequoia: "9d25a72fbb101295e222ca3a428b0cead81a48cb93d4f5a993203793f0b1e451"
    sha256 arm64_sonoma:  "838592a775bc85242342a083096483a0c3f980ee3a896c5dd8ce7ce73b23c447"
    sha256 sonoma:        "d7382388698e26463ab9db47f84a30f2c1b3ea1e4477b005015e99a876689662"
    sha256 arm64_linux:   "8d4707adc332f73926b8c8e478e560fbcb501c0a5b87d326f9c8abec5954eeef"
    sha256 x86_64_linux:  "c235f6f3aed36c2ac590f460f8b4469711c468ea545fd5ce4bef2ec660aa34d4"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "hwloc"
  depends_on "imagemagick"
  depends_on "libmaxminddb"
  depends_on "luajit"
  depends_on "nuraft"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXPERIMENTAL_PLUGINS=ON",
                    "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}",
                    "-DCMAKE_INSTALL_RUNSTATEDIR=#{var}/run/trafficserver",
                    "-DEXTERNAL_YAML_CPP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMAKE_INSTALL_SYSCONFDIR doesn't work as install_configs.cmake prepends the prefix
    configs = (prefix/"etc/trafficserver").children.select(&:file?)
    pkgetc.install configs
    (prefix/"etc/trafficserver").install_symlink configs.map { |config| pkgetc/config.basename }

    (var/"log/trafficserver").mkpath
    (var/"run/trafficserver").mkpath
    (var/"trafficserver").mkpath
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_server is not running", output
    end
  end
end
