class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.25.1.tar.gz"
  sha256 "2e3978da257eaccf1a53ac6323f0a60b98fba75ac3e891db6b4076f8022b7633"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98d7655a1583a7b6ee40cb0fad27461571406d2f25810dcf670d4b6554b44a17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cd525e912a72e5055d9e21e67f2edba7aa3271c7e7d124b3616b16b86466ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd045a1d13d24da13b09ad22a50ef0d14b6cf12d4f7fb53e7b65dadc4499f3ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "454e50c7802f209cf81228f50bc83f4aab944d411c84d5f3d14eb4a3be071c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b40be45293698ea85e1e072df7f81d760cd9b6c5a066a6d7c81cd5d310a0107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd79a4e1b3325d6fb031856b92e31c482820c8398d6b7b81b0627346e56af3b3"
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
