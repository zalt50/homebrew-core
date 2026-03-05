class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14cd63e267c22e3b4b137ee90c9cc43b5f8f94e9db99634470b9e2824ed5ac5b"
    sha256 cellar: :any,                 arm64_sequoia: "f682a69dc065379f6d23e3df54efa768d0ed1c98504d5ad2979d9b0daa34f88b"
    sha256 cellar: :any,                 arm64_sonoma:  "a72eb597042e63a3c24cf4685dabdd6f44e048bcce481288fba1ca36771e3163"
    sha256 cellar: :any,                 sonoma:        "f7adc9ef7e288ffa066325527473bd49fa6bac40ac2868a8cac8b5e7a1250eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c695a9ca4ae5f366af1e30b73d9845d3dd1bdcd219399ab929e9bd0a401f382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff08f7fd803834b72297f25ae6da970f06e512a4314af3188b615479922d7c2"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
