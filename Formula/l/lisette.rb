class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.11.0.tar.gz"
  sha256 "00486a0f395b4cc20916122f5202376c5b40c143775e7060ddce5b360ccd7547"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b829d3c5f2b5f225740b811e651c45c18985d2c92d581c0f66ee7bd6b04680"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55aaafd03bb319208cb0da8b726192cbdf91fbd35c2112768deb4f8b24e114e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "823a8bcb7c5b9b730462adc6f71824df377667f56792489ad4dd32f4c23835c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2790c966017a8cc9b8f9c6d9a2fe4d6ec7a17a797c64e12cb551e64e82a45247"
    sha256 cellar: :any,                 arm64_linux:   "430ff4b45cf456df34f04385732b4f06c1cec225858253b5d57fc730e14ddd4b"
    sha256 cellar: :any,                 x86_64_linux:  "7d5d64ba056db35cd55e7186bfc169f71b09bb8b4d8a7828cf17a80dbcdbe4d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end
