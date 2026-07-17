class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.27.0.tar.gz"
  sha256 "18e2a0f4d80196c4b77f42143219eb16b366ca17a146fe57c74386c051369e5c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef399db47a8ff1bb4ee414372449381488eca07587a6d966c69fd3bba78cc41c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b778b491975aa6ddbee492ba98a9c392aa4694b51f2a1a721ebd069fa082eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a9b7ad15fd36a3a1988f2c4739fddf903cffa29d9f2f939f23fa3c7953cd8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0b1398e9af58e27b7416a01dfb1191bc2b829ed0c23aa68368ddf8445ab40b4"
    sha256 cellar: :any,                 arm64_linux:   "b17b37c7676cc2453d5e06d84ed9435a6b98b4c7518b31cfdff46cf93fb84a6f"
    sha256 cellar: :any,                 x86_64_linux:  "0313287b465e2e6d78a85f387777111f32c97eba14377b00f09dfadbb4a50baa"
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
