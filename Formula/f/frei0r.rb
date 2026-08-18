class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "22ac75376236f75df6e2d17bb84ce366b93d80f01f9ac1c5b1810eefac940b3e"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2706c42afd45857c29cc0fb7d708485974f2847926d8bd5ce7f124bbc5dbecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb5327841ef628a79c0f61e80bfb7642f6c3463d6a554ed6d7531b6547961f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfbb5f11a01fc128c6682ae7745d793e0cba8f4750a453e95658118ec827e97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f8ad866f1cc1c63348a7cf80d321a9727eb078e79538b72a7f1e9ba90a46ab"
    sha256 cellar: :any,                 arm64_linux:   "b99d78dbeebbbfe344310bc32898fcd3358bd95ed71b9e3f23fb609fc2fcfb1c"
    sha256 cellar: :any,                 x86_64_linux:  "d78c0812be35354b4a07e876d52501e6d1cf389ca5eeb0ed14a1fcac673865e6"
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
