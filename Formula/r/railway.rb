class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.31.1.tar.gz"
  sha256 "926311876c07135627518938aa625c85c48d23bb916b98711bd8ef4c7f43aaee"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85fc823ad23b49e69d3de63df1b4625c001e90193ea80ce4121309167d995e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b1ea4be4fd9481dceb7e10b0d455825a335ffaa3e5de535275e9279177a913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2bdeba31502651e003d27639770a463eb7915c4d25d89ede5efdab0e1a562d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fff594d9582c21081313784941f0f9866a31b6dd343f80aeee7983d9f41326f"
    sha256 cellar: :any,                 arm64_linux:   "ec028e496cec935de41c3324190199418d1db6caa884e9f693b5e174dba657a0"
    sha256 cellar: :any,                 x86_64_linux:  "11202f58d2e72cf16bf0d955c3d10837270cbf383bd92de017a5d56fa1941ead"
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
