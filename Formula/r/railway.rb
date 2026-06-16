class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "f44543400618bf1e7d28cc3d4cd533b79bb6962370fa15537c08edd31663c91b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8813a7ef575027c2e1da23e4e438e84f916abd33ab1e910e8800ce96638cb16f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3f105625f32df12455d1ab0e07e446615dee8cdeed4248cba971c651a5767d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73528ad36136950ea3cb0e4c2aac37f5810304217976d1d10bca4314e955762"
    sha256 cellar: :any_skip_relocation, sonoma:        "14b1837d34c3703acf7f99fa63dfaf977c4c52235d7cbc347eb29c2b9c36c8b7"
    sha256 cellar: :any,                 arm64_linux:   "840dd94b51a8c05562a9a17b8669d0e5f84650cbb9c819926c9cb06643d8e568"
    sha256 cellar: :any,                 x86_64_linux:  "e8c4ac514e7eb3a3cf4198730d10ebfc1696ae1198408c1ae0171c3563894ac6"
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
