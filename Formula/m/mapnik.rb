class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.1.3",
      revision: "838a1730b239c64b49bc4144a4165e093a6d5bd5"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "941708b7ab4357e57d8b080082f88ae59f43b05e002768008493c3248ce458b4"
    sha256 cellar: :any,                 arm64_sequoia: "8461369eb7830806e0d190fbec706953b1e1ce06e5e6691c19805c5f7e009507"
    sha256 cellar: :any,                 arm64_sonoma:  "807ef6ca1ce9713f8c4ce99b810f0903782f4e128994a8b6f6054f218e86b1c2"
    sha256 cellar: :any,                 sonoma:        "6a4c5f9a44961361d18bacf5e547c3a53b49308255080d7bf4b8ad6b9b5c069a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3363a5547929feadbe7d41899af7ddda2cf73302dc0b9d2d7d33011e9f76dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c42d2564125ff658f853106a7dac75f087b9eb50e6432e01e22576e7a0f76fa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "svg2png", because: "both install `svg2png` binaries"

  def install
    cmake_args = %W[
      -DBUILD_BENCHMARK:BOOL=OFF
      -DBUILD_DEMO_CPP:BOOL=OFF
      -DBUILD_DEMO_VIEWER:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkgconf"].bin}/pkgconf libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
