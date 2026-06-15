class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "b541cec406065c123bd0a71b8ed6d206c00b1e7e79f0639e61dc6603f5a09253"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "168d74e293269d49475c35e37e1f2a3fb3491d1cd972e3a0d4427119a516045b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5213c9480d40ccabc8a51d73238abcff88e491461f9cf0146cd2c5444dd4ddd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e34701cb3f740c07fd46078911d5197e2fed6abb2228d592c7df73dc85e33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54081f3f8f5333eda013bd8ecb9fcbabc3432641a87458616a50dc504ffc19b9"
    sha256 cellar: :any,                 arm64_linux:   "9d0061c863760de8f70f8b5fb707bd1dd79ee675832896035a5b5e0e6b8b01e0"
    sha256 cellar: :any,                 x86_64_linux:  "c414a2106e13d0b1bfa19e78535228e630c3a700e2a444c55afc0126108ff602"
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
