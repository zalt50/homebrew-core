class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://github.com/arminbiere/cadical/archive/refs/tags/rel-2.2.1.tar.gz"
  sha256 "16d24cc143632b9990a3fbe062e2858d5dd9599a0f369dc02a40c2a76036f931"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeddbf1863fd8e576ce949825769b6a274b4def62ae180b5f5bb39365577f637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5573bfca52ffbcc554510d1a52237cd9ff811892ba7f4be87ef76215b04525cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a790e8cde2ad2099838f1e14b4ecc0c557edb46398a1039dadb313599049eb1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e364b0383b81f52e884acfef27c24d6a812f06f706f3fc2c43a47ee690efc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcb814996dbe5622564aeb98c401e3b75f04e2d8be58854564e20690cbe3c1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4068d537839f8c5b616ae67cf8f4875daee73a2f736b63f5d2f6e57583a997bf"
  end

  def install
    args = []
    args << "-fPIC" if OS.linux?

    system "./configure", *args
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "../src/cadical.hpp"
      include.install "../src/ccadical.h"
      include.install "../src/ipasir.h"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cadical simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.cpp").write <<~CPP
      #include <cadical.hpp>
      #include <cassert>
      int main() {
        CaDiCaL::Solver solver;
        solver.add(1);
        solver.add(0);
        int res = solver.solve();
        assert(res == 10);
        res = solver.val(1);
        assert(res > 0);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end
