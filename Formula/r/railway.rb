class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "2de601b482b403ae92b9156990c86b8d542671e783d5d84688a22a6daff7f4cc"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70ca625f7731a51c166e3a88667726731c35cd25f9a9277048b68edf6991a27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110541505255946bb79e1425958bda4d3a6eb0e0a7ef250a33f0688f8167686d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1821ddd1d2a4b623582914f41f8361526488eb940cd33a9664b9f4e413688064"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c2545db06e6ef35593be799a6f9b4cce92a6eeb6efa8680beb5933cc154376"
    sha256 cellar: :any,                 arm64_linux:   "4333c9eee3723a645817f0ed4d6cec379fba2c5643d0cc96c415b1936ad161c6"
    sha256 cellar: :any,                 x86_64_linux:  "5d67f2ff763144ea9df23c608b43560fb1d8c6b7296822ef1b8b7c512889a252"
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
