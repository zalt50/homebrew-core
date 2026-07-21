class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.17.tar.gz"
  sha256 "990119d00e30377e2a909529f55841443f1ebb49ef725b98c5c0dc28149edf84"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f77f688a9aec0aa43c610e482870318fdc612e2fad555453d9204d4faa57a44d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77f688a9aec0aa43c610e482870318fdc612e2fad555453d9204d4faa57a44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77f688a9aec0aa43c610e482870318fdc612e2fad555453d9204d4faa57a44d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef90d855ef0f49a3a142ef78da5f1fec2f0cf7440644aaeca1a58dbcfb92a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "819c8bc14fbbf643560ee1b918db65d0c9696767eabe0a6d50f312b2d20c9e31"
    sha256 cellar: :any,                 x86_64_linux:  "232f414e2c6ad0b979993842b7b6e846d58f40b676795cf4a59a65f199338c6d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfcmt version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    ENV["TFCMT_GITHUB_TOKEN"] = "test_token"
    ENV["TFCMT_REPO_OWNER"] = "test_owner"
    ENV["TFCMT_REPO_NAME"] = "test_repo"
    ENV["TFCMT_SHA"] = "test_sha"
    ENV["TFCMT_PR_NUMBER"] = "1"
    ENV["TFCMT_CONFIG"] = "test_config"

    output = shell_output("#{bin}/tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end
