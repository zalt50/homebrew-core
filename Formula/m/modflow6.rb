class Modflow6 < Formula
  desc "USGS modular hydrologic model"
  homepage "https://www.usgs.gov/software/modflow-6-usgs-modular-hydrologic-model"
  url "https://github.com/MODFLOW-ORG/modflow6/archive/refs/tags/6.8.0.tar.gz"
  sha256 "e031d000eeacba00238421379e98dbcb1d4928fedaa4d9665d92932eb33dbaed"
  license "CC0-1.0"
  head "https://github.com/MODFLOW-ORG/modflow6.git", branch: "develop"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install ".mf6minsim" => "mf6minsim"

    # zbud6 is a utility built by the default meson targets and is not packaged
    rm bin/"zbud6"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mf6 --version")

    cp_r pkgshare/"mf6minsim/.", testpath
    system bin/"mf6"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read

    # run the same one-step simulation through libmf6
    rm testpath/"mfsim.lst"
    (testpath/"test.c").write <<~C
      int initialize(void), update(void), finalize(void);
      int main(void) { return initialize() || update() || finalize(); }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmf6", "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read
  end
end
