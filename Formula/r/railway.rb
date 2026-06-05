class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "6f50eb742230057f3130b8e2de6f5f48dfbb36671bda441624e44cf0f962e6d6"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6006a661b386cbb3e1589058468042aeac5a50b59755be377c6757f489ec7789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f67d35ae087db5cbc06d3a84377b4241de778bb944a5eb8e84d4198f1d4caec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56e32d3e9d9593f645514b0cdd64c0ea71e73b722d9b44880189abf2ed8d1f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "190a1e6711fd17e1bca90577eff520384c776ed4145c2638d79e0405ab7029e6"
    sha256 cellar: :any,                 arm64_linux:   "b6378c2efb1c0555149ea6a5ed488f96b5ef34a76f68b1fd5934421dbb2f9db1"
    sha256 cellar: :any,                 x86_64_linux:  "1e61af26ffab4f73a75a34cc390a5b2da233a7973cd96d42a33ebfceb356589b"
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
