class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.23.2.tar.gz"
  sha256 "6155cd2577fe2be525c2c109d439e4c6d57ffbcd4d0eefee027bc5d1929aec3e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fefa49c26adf0ed338ea062971523eabbacf2e07577ddd1ef52b6fa750ccf19f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a55582b00a1216a4272e156e4941d56e77509f964919589b9edee1e6f39ac5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea888c48d7d8fa0fdcf4a3f4288ba3a4209e538a177a1e02297eca6f7754474d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3eb7a956df224a85348ff846d26b7312ca0b8e13f021db329850a0b962e845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d7dac58a2130b4d2bcb5a6505d64a91d15dbc9831f2745366e8a55c5afe1b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499791c3905c8c4cf3b6f69cd3bce7a8bc39065546018c3446d5aec7c72abeda"
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
