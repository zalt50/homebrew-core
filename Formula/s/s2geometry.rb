class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://github.com/google/s2geometry/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6091ca0138225f3effbd80b9c416b527c66eb30460f3f050f45345a3c0c1c79c"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3afb04ad4124a7211dcbb60f652c05df77890ee82843ba1c73912a911c5fdd5"
    sha256 cellar: :any,                 arm64_sequoia: "bda10e17366dda59e3a246f452b055fa0c2d1bfd768bb416812c06444a0d2129"
    sha256 cellar: :any,                 arm64_sonoma:  "c8cf0a0a38864127e72cac71adefa4ab9e7cc9cb1fa4a2b7513c75a23a6e0f56"
    sha256 cellar: :any,                 arm64_ventura: "9f0ee847a51923a12b403b60f957a1abb06dfb3eeda55d72a56d0977f3bdb26e"
    sha256 cellar: :any,                 sonoma:        "b75a7923b114c655686a613d5e130b9ad2f18255b2ee82530d611790d342937f"
    sha256 cellar: :any,                 ventura:       "fedf506c32f5acd95dd44ade41722d5de8f8c6072f190d9c9a58501f6e2d8d96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c4afb3fbd50cf72c3bbc09610de2777cc209f51961f8b6dd905310055c33b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90df62d0206fa6c4e90df95b4e7e07549818de81a4fd8979ba441fd528d5a02"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    args = %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DBUILD_TESTS=OFF
      -DWITH_GFLAGS=1
      -DWITH_GLOG=1
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
    ]

    # Fix missing include of unaligned.h
    # Issue ref: https://github.com/google/s2geometry/issues/481
    inreplace "CMakeLists.txt", "src/s2/util/gtl/requires.h", "\\0 src/s2/util/gtl/unaligned.h"

    system "cmake", "-S", ".", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DOPENSSL_USE_STATIC_LIBS=TRUE",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libs2.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "s2/s2loop.h"
      #include "s2/s2polygon.h"
      #include "s2/s2latlng.h"

      #include <vector>
      #include <iostream>

      int main() {
          // Define the vertices of a polygon around a block near the Googleplex.
          std::vector<S2LatLng> lat_lngs = {
              S2LatLng::FromDegrees(37.422076, -122.084518),
              S2LatLng::FromDegrees(37.422003, -122.083984),
              S2LatLng::FromDegrees(37.421964, -122.084028),
              S2LatLng::FromDegrees(37.421847, -122.083171),
              S2LatLng::FromDegrees(37.422140, -122.083167),
              S2LatLng::FromDegrees(37.422076, -122.084518) // Last point equals the first one
          };

          std::vector<S2Point> points;
          for (const auto& ll : lat_lngs) {
              points.push_back(ll.ToPoint());
          }
          std::unique_ptr<S2Loop> loop = std::make_unique<S2Loop>(points);

          S2Polygon polygon(std::move(loop));

          S2LatLng test_point = S2LatLng::FromDegrees(37.422, -122.084);
          if (polygon.Contains(test_point.ToPoint())) {
              std::cout << "The point is inside the polygon." << std::endl;
          } else {
              std::cout << "The point is outside the polygon." << std::endl;
          }

          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
      "-L#{lib}", "-ls2", "-L#{Formula["abseil"].lib}", "-labsl_log_internal_message"
    system "./test"
  end
end
