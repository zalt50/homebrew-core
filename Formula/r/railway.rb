class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.9.1.tar.gz"
  sha256 "ed2657e6f444c70968536327119b0f23cc0b42f0286ac6f13d272e050d668a86"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d8d628dd07f7d216aa800cc27ade7ce69b4bce1aa2778296eb64dea3f7da7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6cccc7a325562b1668d3f18c30a7f948258bc5fa22fba3f866a007d428c8326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b609d8f39ab34064a1be9d4b83b982f5f14c41ae6bd58c66383f4a3e8510f5f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8571e793b736558e5aa485b2a90a3e75f204fe6576b5f40a861a8200f5cb9903"
    sha256 cellar: :any,                 arm64_linux:   "c7fd5c9f394bd81857691a19c133d719a5711144faa951a23f7e3e12fdec905f"
    sha256 cellar: :any,                 x86_64_linux:  "c0496856a2d1b7580b109cc8b44983d02c579f9368afb8e97f1652f789cadc0c"
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
