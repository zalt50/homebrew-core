class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.5.tar.gz"
  sha256 "1deb009ffc832382529e72da804480696e9cd8f51117b2202907a13866b96a2a"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b2d71c29e673f8fe425c63848154ef5e824de624268023a9e56fe9f3b99b6d0f"
    sha256 cellar: :any,                 arm64_sequoia: "5239fb1cf825cfdfbb4a697a5c3009b1e5899c8a74ea64fcf932f9fc961fd268"
    sha256 cellar: :any,                 arm64_sonoma:  "69bc8c2ca51ab1df9daef08ef1ed3eacd438d8d6125b1d659206e1f692381ff6"
    sha256 cellar: :any,                 sonoma:        "a67f35b0592b480831b2463a17dab5f7d9f637eea03d27d3c469f59be807b25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b60138350eecaff614b7ed419457f26e4a837d2155c826c49e40e8bc5c9a50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c56b827004dd4770e742065676caaf01eb3cae78ef4888502ad2b42273d7b42"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/ade472d3dba145fd53c19d486f5916b6259449c6.tar.gz"
    version "ade472d3dba145fd53c19d486f5916b6259449c6"
    sha256 "fc42be82d65bab670b6e100db18776048e5e506a8a6aa12da64873e3f5bf8d03"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback/archive/35f027383abf3b4b52bbc8af789c8f1aa3d84ad2.tar.gz"
    version "35f027383abf3b4b52bbc8af789c8f1aa3d84ad2"
    sha256 "c0066295ccf209617e18eba89d5fc8b3d4baabf2184441bdaea600add32a2453"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadiback", "locked", "rev")
      end
    end
  end

  def python3
    "python3.14"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    resource("cadical").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"cadical")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("cadiback").stage do
      inreplace "CMakeLists.txt", 'set(CADIBACK_BUILD "${CMAKE_CXX_COMPILER}")', "set(CADIBACK_BUILD \"#{ENV.cxx}\")"

      args = ["-Dcadical_DIR=#{buildpath}/cadical"]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"cadiback")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      -DBUILD_PYTHON_EXTENSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}
      -DMIT=ON
      -Dcadical_DIR=#{buildpath}/cadical
      -Dcadiback_DIR=#{buildpath}/cadiback
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    site_packages.install prefix.glob("pycryptosat.*.so")
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
