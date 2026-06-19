class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "3cef799923eb3ce1814a66a223c32f0db29a842d85f91c2ddbf8b02a01c2290d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514d4abb7db3c61b40a445f0a2190372b634ae7a90205d5f1965b6cca9eb9c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84612ba5218795c3e282a3d87e5b65f399608e7a2a15f021b9326fac1583cdc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49918849df058119c567ed7f818bb5b6b42232bbfdd54b58d14100bfa79bf6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d66ab1aee01e58a493a07b1a1af044cecf65c07c5d3a030f2815a298dd8bc67"
    sha256 cellar: :any,                 arm64_linux:   "795d32af0d2e17c3cd06e8a6ae1d2b0d341222e4fdd4ddaacde560cf3c9c1aca"
    sha256 cellar: :any,                 x86_64_linux:  "0e8b8c9219142c520ab1cd874aae0274b7cdd2f0247088ec9b0ff2b7c06a6144"
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
