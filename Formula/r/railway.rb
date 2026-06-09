class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "6827594ce65e316ffa3513bf2903e02d3f430235a630ba42f8782ccd589b2eda"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57367008086c311813c15c85cca707b3376fc9256fe44a4b268e0408caa0218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9cfe7d09821c19fce558c0fae27182daea0acd5b9a68c7ea3d3e74207d1b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c2b9aaab52b96d5a064a1c67d256c67e005e480d036c585788640abbcbb818"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f224f3120ea3acf8c9b9afe4e9bc8d46116da6eb89b21b4d45741fa549666a5"
    sha256 cellar: :any,                 arm64_linux:   "722c749129be6454f57e92f4f773c03048b2f4840b4f553a2f0664cfdf9b266f"
    sha256 cellar: :any,                 x86_64_linux:  "84c8ccbf9c2f653072a5af693096e280b0714dd7464e6914c29e29e429652c84"
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
