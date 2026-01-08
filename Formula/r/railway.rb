class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.18.2.tar.gz"
  sha256 "7eaab65be401d4e9904d5c5262a2b6ede1a1338a5f17aa2a88534cf6e963b729"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bc99dce54c41f7fa3c578b943ee8baf9db2a243cda23c2d70fa206afadc07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f9e7afe25dae7ec85838166aa2ab8fd42692bce2e38f8b660930a67cb2e764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c80e9cd176f97cfe79b0d1cf8a906d9b4c5f39221b4da23c67e9a5bbfb7eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "49013e4d2418519f9de7cdbfb37f82704235f87ea237bad8fe17646a3df23aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f41929493d2e45c9dcd0efe3ef9206f89b97039fb8a5d70e2fb8334f3f138d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc28b57a1ad0f879b7b1d51dd5c2b50c4ec6605de837d234c01f89a7ef8d6cf"
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
