class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.37.4.tar.gz"
  sha256 "630e3e61c1327be2409419780014d874f0e8b0d42473d828602adc9a713cb4cd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c28a6270013bbb3fa0f37772b518c0e3c4e87590794e990d3c081777ebc6973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "109ceba666d5c4dd93601f1a39a9a4087065ddee9905bfa29126b6eace165d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0110f88ef6fa4a0ecc95a97b850e6a499523695d774465616fd7354bfbd0e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cbf2aaef836e79edc570741d5945a12d2fd82082dcc635f5273d50508d1fe03"
    sha256 cellar: :any,                 arm64_linux:   "0493fe0277751beb99c69c1aee96ac5c87d95d4665d68374be8bd0d3176e6a4b"
    sha256 cellar: :any,                 x86_64_linux:  "b4ceaf25cfd407bc2ca4b315e891932ada478603f2df1c49aa0f94d3e74ade78"
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
