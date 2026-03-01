class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://github.com/VowpalWabbit/vowpal_wabbit/archive/refs/tags/9.11.0.tar.gz"
  sha256 "ccf3810413bcf35314ebfacced3e2186b05d9d8fa6e4dfa9d2ef34ed7d9b50a5"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ff869cf19aa55a6aa7d3433e576680be52cb95ff6f80062ab53da763eb39200b"
    sha256 cellar: :any,                 arm64_sequoia: "79cdb8d2ee6df0fe49582194dc69a310a5491ac0602e27c54b75b182fa8e8973"
    sha256 cellar: :any,                 arm64_sonoma:  "2a8d8216335c12f14f3285f3fc0193c0b1b72a6ba2987c4da3a5aeb34e0fc978"
    sha256 cellar: :any,                 sonoma:        "f550eacee245b32b6079af6f4e5625ace1791940bf00b062c9ce98121ca7e564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5329e9fb644bf34ed2ec521ebfbddb67339d7574d0021fefa5ab163a25834a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f5fe1db04b31f5e63c071b9071f9e8bf843f8ddcea109c95a6d5f2c7ec9748"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "fmt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "sse2neon" => :build
  end

  # Fix system RapidJSON packages that export include dirs but no CMake target.
  # Upstream PR ref: https://github.com/VowpalWabbit/vowpal_wabbit/pull/4902
  patch do
    url "https://github.com/VowpalWabbit/vowpal_wabbit/commit/887a1fdf2d3443b615bd8b4d066518eb84fbb693.patch?full_index=1"
    sha256 "1204402159a276d31f0883dbdb3191ad6e5e084dcf90e7d8cd3d349c89f70ef5"
  end

  def install
    args = %w[
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=ON
      -DVW_EIGEN_SYS_DEP=ON
      -DVW_SSE2NEON_SYS_DEP=ON
      -DVW_INSTALL=ON
      -DVW_CXX_STANDARD=14
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"vw-validate.html"
    rm bin/"clang-format.sh"
    rm bin/"release_blog_post_template.md"
    rm_r bin/"flatbuffer"
    rm_r bin/"dump_options"
  end

  test do
    (testpath/"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin/"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin/"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath/"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin/"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin/"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath/"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin/"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin/"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath/"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath/"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin/"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin/"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end
