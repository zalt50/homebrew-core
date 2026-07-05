class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource/archive/refs/tags/R19.tar.gz"
  sha256 "bbd391dd2725ae68994e0627f4a57b484d37b6e8d150276f07122e89fb6cda5d"
  license "MIT"
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e236de5a78086d9668b5bc13b58e9616e1ac2e2fbd3f20c898203bf10375442e"
    sha256 cellar: :any, arm64_sequoia: "4abcc655778bb0d2b3d1dfbd16a38e3745da1cbd8628c7e595c2c8f9ea98acef"
    sha256 cellar: :any, arm64_sonoma:  "0b41febb5c50b99351f3ade9817ab3959afdee698f9c86adf16f89d49a094d31"
    sha256 cellar: :any, sonoma:        "e875d1f7c365bddd3dd8038f95ffee2d79823cfaeea431fd27d7008c7640134d"
    sha256               arm64_linux:   "c1766358364188b4c3295a11f5a97a79d92b6b10cbac0ee2ba264d154e1b4c84"
    sha256               x86_64_linux:  "cb5ae4c2ad0c0b435b2e4591f2407b76fc1472a0423bea9f7d833ee496bae4a0"
  end

  depends_on "avisynthplus" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "vapoursynth"
  depends_on "xxhash"

  resource "libp2p" do
    url "https://github.com/sekrit-twc/libp2p/archive/869fa993041f9f3af7d9ac8b10158920c6ddce66.tar.gz"
    sha256 "cacef2683a19a8b288cf567544b507f7f06dd66160db566bf3349e5ee0b73d90"
  end

  deny_network_access!

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    resource("libp2p").stage("subprojects/libp2p")
    (buildpath/"subprojects/libp2p").install "subprojects/packagefiles/libp2p/meson.build"

    # upstream expects a subproject, but we can build with our avisynthplus instead
    avisynth_pc = formula_opt_lib("avisynthplus")/"pkgconfig/avisynth.pc"
    (buildpath/"pkgconfig").install_symlink avisynth_pc => "avisynthplus.pc"
    ENV.append_path "PKG_CONFIG_PATH", buildpath/"pkgconfig"

    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    # Using nodownload as nofallback with `--force-fallback-for` can download HEAD git repos
    system "meson", "setup", "build", *args, *std_meson_args, "--wrap-mode=nodownload"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.bs.TrackInfo("#{test_fixtures("test.mp4")}")["codecstr"])
    PYTHON
    assert_equal "h264", shell_output("#{python3} test.py").chomp
  end
end
