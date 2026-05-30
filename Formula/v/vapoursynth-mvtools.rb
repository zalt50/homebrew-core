class VapoursynthMvtools < Formula
  desc "Motion estimation and denoising filter for VapourSynth"
  homepage "https://github.com/dubhatervapoursynth/vapoursynth-mvtools"
  url "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/archive/refs/tags/v28.tar.gz"
  sha256 "48d59695f953ba51dc31911b062417f6ee8f88bbae21a76ff92a4918800ce092"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhatervapoursynth/vapoursynth-mvtools.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.mv.Super(vs.core.std.BlankClip(format=vs.GRAY8))
    PYTHON
    system python3, "-c", script
  end
end
