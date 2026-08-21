class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "c72fff563ee798a17f6e9033e0ca6847bf1b384bc581630661470820548855fc"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3cc376b8e68c8bd8a08709f73aa58d14bc4ff3c67d69acdbdd1b8ac5a6ac76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4675b5cffbf57b789692cf0a761fdc94b83bd980ff8c3b6695610f8f7fb0b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f9465e4a3c8235e2cb0a0af3521169486b8a8da315f24df2f1281960a03712"
    sha256 cellar: :any_skip_relocation, sonoma:        "6397996a0b5ac735d121d42d4e8326b7081792220bfe0437957759e19e98618b"
    sha256 cellar: :any,                 arm64_linux:   "62b0a958dc27e356bc5a2049bb1391605d89bd2b2be08bef6886d062a267b217"
    sha256 cellar: :any,                 x86_64_linux:  "1e2d429c064e221767d45ed0a6a72db737f61cb8af6c92beeb913d2121bf9a65"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
