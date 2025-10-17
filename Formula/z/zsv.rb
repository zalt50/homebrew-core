class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "218d184dabf847f97f6920dfa3ed4626f6816420109e3d15739151d7bfeca2ec"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  depends_on "jq"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install", "VERSION=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsv version")

    input = <<~CSV
      a,b,c
      1,2,3
    CSV
    assert_equal "1", pipe_output("#{bin}/zsv count", input).strip
  end
end
