class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.38.0.tar.gz"
  sha256 "de528106194d275c5936524d8e331555fe107ddb49b1f8bf161c3e505667ab81"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c4fd6c29fd20d6e494185d3b45801ef4a53206d19bbd6d25590d1d4516a4f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de1e2b3e593eb5a278d21f7c74b85557ba5b6c70bfc2bc3044e944e85e639e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1262d4d2aa2581424fe00c3aa496fa7d77ee8b2053429aa9018eb58e523d56f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbe427a1289eb282a91ff206bfc5092d804470f0cfbac56eade529c847183c4"
    sha256 cellar: :any,                 arm64_linux:   "1b039aec46527b5018cc361a002ba7871b55a1170ca1118194096278244be969"
    sha256 cellar: :any,                 x86_64_linux:  "bb5369226c45f5363b5e600b54d43e24d018f1d06fb1492f00bb5ee3ed1c553a"
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
