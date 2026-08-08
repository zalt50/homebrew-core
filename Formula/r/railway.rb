class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.34.1.tar.gz"
  sha256 "52f2623534f8c71769f9e53168917a2d1d30d38dd1e37039d54739fa141294df"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa510723032e1b53dd5bb4fae580bcd4ca21be4fe0a795c57445488cd6137cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec863cb4ba1374efa0a6cba904b4d451150b4f4327a1e06236809a68f482ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2f2c77ccb00badfa7de9a9d19ab1dd0a220d5593441aa7df63ee17331097a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a601b121790ea221cd0bf9ba024da7de42a32e965b405cd198eca3d60223a3c"
    sha256 cellar: :any,                 arm64_linux:   "5100e934716f2a02dd80d2bf03eddeb19e35952a72383767ffd48ccba7ad8fe7"
    sha256 cellar: :any,                 x86_64_linux:  "53832341a5938eca4df4becc71b39820cc227c481920ba4a2a50eaf9d1458170"
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
