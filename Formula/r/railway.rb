class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "6827594ce65e316ffa3513bf2903e02d3f430235a630ba42f8782ccd589b2eda"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd19d1b209bacc2cf825d82a143f4fd2d8fb126ef0b4fdfedbf4942276ee77a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e262b56d9a7b593eb9a82d574b68c12d791ce14d5eb96e42c2cb795ac68c363b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1f88dd41442cbdb0da17c837e04faf6f984c7e9e72c1d35c7e3acb489fa446"
    sha256 cellar: :any_skip_relocation, sonoma:        "47dc842b0bc29471a3fe40e6564829f848c7ecf594f54ea4d5d87a97cb7a5e75"
    sha256 cellar: :any,                 arm64_linux:   "4b91484e8b3062325b3cd1ea15ab138b256f2307dfd376d03485b5f203b8c846"
    sha256 cellar: :any,                 x86_64_linux:  "6b0dccccece6cb0eae7b6c400c8c1b3ac8983f1bcff9346b2e96606c956e8a82"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
