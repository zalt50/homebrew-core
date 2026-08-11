class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.35.2.tar.gz"
  sha256 "6d2bfbd82ca8ce3e91187ddfc3302536bc00d660f5b085a39038c9a18d4abe09"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ceda5971bf382ea58e0f5cb87c246f756c2d5b01d6a1b0c2c2183ca794784e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae4fe6fca8db48bfaafae95d87c65588a66ad447bcf28289dd122555420ebe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbde2c544c8c6da0e4b15b6754bb792f187b3833941b37323e0335a9a6ba4308"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7365566f3354e26db3b4ace16d0a640efd19c402402821e6ca9ef3eb3b9f65"
    sha256 cellar: :any,                 arm64_linux:   "8b922ab3562b3b8a04a127d16da79f98533bd22be3c90d3ea4f20e8729c492ec"
    sha256 cellar: :any,                 x86_64_linux:  "6451bc213824fdf635f461ad630f5b89a0132662d27f57979a8f120662de15c1"
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
