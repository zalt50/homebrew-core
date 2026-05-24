class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcc2aba1bcfa939b6714837a17bb06db78a66a0c80f30369fd88b8df3bf49939"
    sha256 cellar: :any,                 arm64_sequoia: "bb835f8f806f9a8c6f6c641daf8d2c954e8c280d10b6b5e4a66fa04ade4c0211"
    sha256 cellar: :any,                 arm64_sonoma:  "70f21c246bb76c1e5648d7e57e15cd2f0e1ffe0850a577a06fb28160308f2a00"
    sha256 cellar: :any,                 sonoma:        "f283332082fdba66dd6c1faec52841e9cef4e12611f392c32c59caa49a35ed62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a7827e7014c9e3aefd337503312cfaae8060adc43d1317a37c518fbc3a5a037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d2018532c3849119a0d66c7ba11df7ad69aef5e194de2d3d271e853706ce37"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
