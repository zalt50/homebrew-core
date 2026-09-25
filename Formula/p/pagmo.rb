class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "8d684e9a3667dcccc844489083906c35aba7610594c5fce0f4eccce9c2264f4d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d9840d73678b552f44a8571e277d55509a7a03055852f2fa8bcf8b55579d84e"
    sha256 cellar: :any, arm64_tahoe:       "d6f878e60698b9628bfe904153829e027b81e6298190e2f2d9854b9c29da92f2"
    sha256 cellar: :any, arm64_sequoia:     "0368ede6f188f6b192d8bbccd246d59b180d1e13f466db6f14a6e2f7ccb0fe8b"
    sha256 cellar: :any, arm64_sonoma:      "75da7597ecf58183fe3e3b3524e3aadba8d6793d299377a5942a38aae10f9892"
    sha256 cellar: :any, sonoma:            "8dc83e9418b2bc2d90a11ade348ee0e801e33e54d878d8e295fd3135db07f5ba"
    sha256 cellar: :any, arm64_linux:       "dbe99db548100e7a99083bf8279ac9b54bff157c02411e8ef618c51b6677f1ed"
    sha256 cellar: :any, x86_64_linux:      "9c4dc4a7729b3388229ef412880009cbad4a034b5b8ee661bfed2342abeb9969"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  # Backport support for eigen 5.0.0

  deny_network_access!

  def install
    args = %w[
      -DPAGMO_WITH_EIGEN3=ON
      -DPAGMO_WITH_NLOPT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>

      #include <pagmo/algorithm.hpp>
      #include <pagmo/algorithms/sade.hpp>
      #include <pagmo/archipelago.hpp>
      #include <pagmo/problem.hpp>
      #include <pagmo/problems/schwefel.hpp>

      using namespace pagmo;

      int main()
      {
          // 1 - Instantiate a pagmo problem constructing it from a UDP
          // (i.e., a user-defined problem, in this case the 30-dimensional
          // generalised Schwefel test function).
          problem prob{schwefel(30)};

          // 2 - Instantiate a pagmo algorithm (self-adaptive differential
          // evolution, 100 generations).
          algorithm algo{sade(100)};

          // 3 - Instantiate an archipelago with 16 islands having each 20 individuals.
          archipelago archi{16u, algo, prob, 20u};

          // 4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

          // 5 - Wait for the evolutions to finish.
          archi.wait_check();

          // 6 - Print the fitness of the best solution in each island.
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
