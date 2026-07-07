class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  license "MIT"
  compatibility_version 1
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  stable do
    url "https://github.com/c-ares/c-ares/releases/download/v1.34.7/c-ares-1.34.7.tar.gz"
    sha256 "556f781dd188ad932dc8263fee0ad3aaba675b4cd8e54d86908681b43ce3e327"

    # Backport commit to revert API/ABI break
    patch do
      url "https://github.com/c-ares/c-ares/commit/636f85326908a521f232c7e7acb6c3484582391d.patch?full_index=1"
      sha256 "edc660df5ef02a47b4b8e0f14dad5f24faceeaf2e387cfa6a50336ebc28febe9"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "31d95f39faa99ae238ac17ba33076318c51ff3153bc1f43f8d5c4c4de0e7bc6c"
    sha256 cellar: :any, arm64_sequoia: "a16212e728de407ad8a6f24e2a2e77e08b2f48226fb4e8dfeb2128063f73726d"
    sha256 cellar: :any, arm64_sonoma:  "10c36b85a92ba1008bacf09cf4bdb00567043d7f5ef5be466b656a582c6cd2e4"
    sha256 cellar: :any, sonoma:        "6b6404874116de97753bb8b26754f6c315813ca6df8bd41a0561f1897d9843ef"
    sha256 cellar: :any, arm64_linux:   "59e40c36c93af012ea29a8598438a91178f8a291f1e637f8758b6e74a5709d2b"
    sha256 cellar: :any, x86_64_linux:  "47796f02038044993a377c04fb2a5081cbe612e20a59963c6b4da07d9f056127"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
