class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.30.0.tar.gz"
  sha256 "29a152d693edffbff6538dfd6bacfc91e0e387cc024f834fee3f4a72936b79f2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb7521dd987d25e61c03f04ea3edf2ec2a4f88265053bd8c154aaeac777d88d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddbf2233029b80cb836e2219877c74e6ee5e4f13f5c6bb7301036df058ddcfa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06854b5ca7e5d4945e3f35bd8c49f7d8aae000056e8157136f745833e6030b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "993c7cabf52050f32dd4e2b073b6586307e18cf23e90a1d5eb1c93592a94ec64"
    sha256 cellar: :any,                 arm64_linux:   "2f7131fe81a71918bec952d9e74f09a91f012b36434f77f0e985e180eb724059"
    sha256 cellar: :any,                 x86_64_linux:  "b46d84dd246d7f26b785be9f0a468e00abcb2aef793dff7ceced49c9000c09b5"
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
