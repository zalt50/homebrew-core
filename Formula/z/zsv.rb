class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "18e3edbace5cb9c1d69b5b9a74dc4d6e5808579584c3f44d47a8bbdad548c065"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb226634dfea7ba2f6c101ea87c38ad78cb9b50daf6e494f13da7a6ec94cf730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c73bb29f2215d4dbcb677ae6a80aa2651769c58841e7af2d0aae486a32ad55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daeba412aae30ce92672b27817df5c56b56aafe4b9c9c5a73e16a6a395c6aaea"
    sha256 cellar: :any_skip_relocation, sonoma:        "263aa15d9c24eb9ec949f63d273bc747d4642a13d45896f3f0cba45b053f0901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7ffc41a8c78ab8b07676a2e72c2c1025daf2dc03761584e3c2c837def8db3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dcbc9ec6b71626102095e4f369da25f811c96d23dd80827c2a9a356bb60b8f6"
  end

  depends_on "jq"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args

    ENV.deparallelize
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
