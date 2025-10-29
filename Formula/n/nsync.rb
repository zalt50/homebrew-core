class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.30.0.tar.gz"
  sha256 "883a0b3f8ffc1950670425df3453c127c1a3f6ed997719ca1bbe7f474235b6cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fdf47744fa4557e3c6caafb8688671775c4947ff5748365952b8b66ef817e49"
    sha256 cellar: :any,                 arm64_sequoia: "5646e78dfc90e6ea7a9575f5b51ccb91e142838e61170087a5ea89dd7076d1fd"
    sha256 cellar: :any,                 arm64_sonoma:  "fdcf50215956176ee21750ef95dea641a5464aa2c474e024d63c8032ddc99da1"
    sha256 cellar: :any,                 arm64_ventura: "163b4942545d21ed0042db6343b07b7ceb810010cd513a77d2f2d8060ace3b9a"
    sha256 cellar: :any,                 sonoma:        "03ffb1919593d89b4ce5e8bd58b540ebce76dedbfea579f06dfd3a1578af6120"
    sha256 cellar: :any,                 ventura:       "d8573c05ff6039c4074be9a4bb3119200ce4904e8f55b3747b50c2d9c08cb10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7685d7883604fa8746a3e28034b2ac85632a807d575f0ae5e32173b0c96bc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371b938f9cc2b55990b934c679a18967d749bf7a82783dce7ac49585fedb0379"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DNSYNC_ENABLE_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end
