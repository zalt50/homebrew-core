class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://davidesantangelo.github.io/fastrace/"
  url "https://github.com/davidesantangelo/fastrace/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e9787fa43b6b95af8e439674a73b107b9d0357bdf45f1ffce8408ed2164a44a6"
  license "BSD-2-Clause"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end
