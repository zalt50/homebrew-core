class Csfml < Formula
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/refs/tags/3.0.0.tar.gz"
  sha256 "903cd4a782fb0b233f732dc5b37861b552998e93ae8f268c40bd4ce50b2e88ca"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e33a6a3f34a298c1d64efc5460ed274423457ed95052252dfe1b803b79c26e5"
    sha256 cellar: :any,                 arm64_sequoia: "e1e1172b80909989105f3813e7d1dba2ce0caca2a7efdd2717724e624b7e9cb0"
    sha256 cellar: :any,                 arm64_sonoma:  "1a1763c3710588f2e1eff5569802b195f89582cdc9e5dd842cd818135fede023"
    sha256 cellar: :any,                 arm64_ventura: "0f5543e8c4f83ba20d16b986870afdb4d127326e9b4545b2d98bab4430be4000"
    sha256 cellar: :any,                 sonoma:        "c63caf00bb7ab923a8d49448b410dd7c269fc1a6e8f194326286d610b972f6af"
    sha256 cellar: :any,                 ventura:       "d2d7e9b7eef45f2cd6fa0a48c3f0e606f9690945c8bc7ef396eeeb6640bd62e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8233ef7ba98f94386973b6594231a3fdae9706f0c769aa5ae4b23a2ce12a103f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4c772a79cfa52cd66d37f85c6964473519693d3661f593ede05b4103ae09983"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CSFML/Window/Window.h>

      int main()
      {
          sfVideoMode m = {800, 600, 32};
          sfWindow* w = sfWindow_create(m, "csfml", sfClose, sfWindowed, NULL);

          while (sfWindow_isOpen(w))
          {
              sfEvent e;
              sfWindow_pollEvent(w, &e);
              sfWindow_close(w);
          }

          sfWindow_destroy(w);
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcsfml-window", "-o", "test"
    # Disable this part of the test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
