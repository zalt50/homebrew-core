class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.33.0.tar.gz"
  sha256 "32267e240eb80c0cd98e236b8916b7e525846c76893080dc8d8ecdff624cdffb"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3b9fc87c3d84bdf464423038fba00af0fabcba68fd6cefa98df221b498ac06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f1673c24b3f9d5494e68675a967b6080f270329ddc995f6724067dcabc8b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3946148d331bf6c6fd1aec2e5ce43ec6eb6652994c40394dd0ade4811842d21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86aff1c52d47c72653bd6cacaca60bcf32eb0a4a9ad3c46f3280866ba53797b"
    sha256 cellar: :any,                 arm64_linux:   "55ebe4377275ef787572e13672baa34933ee7d570f4f46f8ee7affe16e72d1c3"
    sha256 cellar: :any,                 x86_64_linux:  "5d8b6db6f5a51ab0e6fd765a72df453e10dd762d5c38ee48769f156ce663522f"
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
