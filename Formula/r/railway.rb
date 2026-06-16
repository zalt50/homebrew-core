class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.13.3.tar.gz"
  sha256 "98a5d1eee10c03cdba9380193577e7328c24665252e4a22ed413deb49980b694"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84015b63b0e68bbb0d2fe4eb7f1e344e68f90bfac4931497d3234f3a93e72a98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e8b2490df7acc7ccd944227bd2fa21cccc3038a1c0ce34d4b1255f8a3b4fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d344ecdcea4ef03c672e6ba7243573992fc160782bd1d509781f5f925cdcefc"
    sha256 cellar: :any_skip_relocation, sonoma:        "049a9f6e7b0c6794e22055736d63c8ae4044738da7f65f4e3478b146e6856d6e"
    sha256 cellar: :any,                 arm64_linux:   "5e130f5a5c9b991c778ddbf80258c83c5c2222885d72237183dc75ff08471f59"
    sha256 cellar: :any,                 x86_64_linux:  "0f42131592d0748365162f976d8ccd047d38f58c2f6ad508cd357f55c3b04710"
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
