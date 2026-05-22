class Nvi2 < Formula
  desc "Multibyte fork of the nvi editor for BSD"
  homepage "https://github.com/lichray/nvi2"
  url "https://github.com/lichray/nvi2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a1ad5d7c880913992a116cba56e28ee8e7d1f59a7f10e5a9b2ce6d105decb59c"
  license "BSD-3-Clause"

  depends_on "cmake" => :build

  uses_from_macos "libiconv"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    man1.install "man/vi.1" => "nvi.1"
    bin.install "build/nvi"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/nvi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
