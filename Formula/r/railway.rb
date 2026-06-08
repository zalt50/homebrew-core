class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "d20bae4111175499b7069e8e92a66f2b9e744726882006f38a0f2c967f209066"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "782428349a0ccb3c05f699e300d5c735b539bfac0d2b867dcc7e6bbf19ad0bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "666e545d1d0443466e53fedec34a8fd044e1c5bd5929a89f08446d05b48cff84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48faeff1b4fa9a918f53afac0f2966aae24bb572ed71f242ae3d94cea4da6223"
    sha256 cellar: :any_skip_relocation, sonoma:        "9545763a1c27b988fe5a536635307cc41001f71fc44ac05ecf0041d78ee59a9b"
    sha256 cellar: :any,                 arm64_linux:   "91ab88cd4e92c6bbf5e988f16c565cbe79e5923d4cddd1d0a85168a509b9c8d8"
    sha256 cellar: :any,                 x86_64_linux:  "7a3972a7c37ab770767d8c3933581f2e23c6d9c7e39a392394936716097f8f60"
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
