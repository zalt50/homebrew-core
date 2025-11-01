class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/flexible-collision-library/fcl.git", branch: "master"

  stable do
    url "https://github.com/flexible-collision-library/fcl/archive/refs/tags/0.7.0.tar.gz"
    sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"

    # Backport C++ standard changes
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/1257b4183e0ae4890294b0edea780605c2533cfd.patch?full_index=1"
      sha256 "d3bb6bc82e926d4a89c19064f79b11506fa9899d52c46a482e3f9b41785b1291"
    end

    # Backport commits to apply subsequent patch
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/beffa1bb54da6686e8167843e051a3f9a2bad6f7.patch?full_index=1"
      sha256 "ab2058f7316e8ad6e9caa253e94c6f8dcad633ae02473d6353b9003552909525"
    end
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/3c2b993a0b1a10f888a53cce4f3c73035ab862c3.patch?full_index=1"
      sha256 "a483773630e9f28c59ace7edacb0a782c9b6a1830514b92e1465ce4828e1111d"
    end

    # Apply open PR to add cassert includes needed for eigen 5.0.0
    # PR ref: https://github.com/flexible-collision-library/fcl/pull/649
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/75ad2bc55acefb6c5638ed2730827530b4b7a176.patch?full_index=1"
      sha256 "6265c1178fe237313e107ae19386d7fc5d69638213d705290ddb61aea0b0fda2"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bd6336e3163c45d2b6a7966cafc3a3dac0f48919e43e189b52e564684ed2b35c"
    sha256 cellar: :any,                 arm64_sequoia:  "0ab8eb79ee5ae022e186975198bd18da7cde25c41cb9e52e70366bf20de59e48"
    sha256 cellar: :any,                 arm64_sonoma:   "6a4d2a1e04f17fb6cf2d7ed92524f09a841c3b212f3ecf22d9dc00dd294bb895"
    sha256 cellar: :any,                 arm64_ventura:  "d147e210255b79430e8fed2455325c53aa0975c2f081b39c44050c5921efd813"
    sha256 cellar: :any,                 arm64_monterey: "05d4d212709bccf7dc0f78eb01882937cdfa656ee019b47493baf6c404d33359"
    sha256 cellar: :any,                 sonoma:         "24a08459f44fe31c2021fe74d4e3cc05dbc32141ad8d941e60c60863229e6635"
    sha256 cellar: :any,                 ventura:        "06b3d235437c8047c3aa7d3951e15e254a6a81dc45546fb34d8732ddeaac68ba"
    sha256 cellar: :any,                 monterey:       "199ee80d6917e61d200cb4ce8fd9516542270ce9eefdfb3139d98f203251fade"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ba0e24c6cbceb1fde43ffafecf538b4b8b6c45ed1cd361deb12cca64db7136a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5840ff43dc2df33f18284bf49f0c29c254d5993d71da5d9939bb18ce316da35d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}",
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
