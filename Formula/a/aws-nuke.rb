class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.61.0.tar.gz"
  sha256 "3a767a76cdd8e451e7c59c51c1593386a2bf5c98438d9313f9cac8d6f584dce0"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a04dc4b6b269f39cd2797ba8590ba126b0b75f4a3e9f9ea28496f7f9ab12df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a04dc4b6b269f39cd2797ba8590ba126b0b75f4a3e9f9ea28496f7f9ab12df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a04dc4b6b269f39cd2797ba8590ba126b0b75f4a3e9f9ea28496f7f9ab12df"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb87f6e4820e6f6d1c4b598dd5f6b289f4b65aa0a5d63396a8d66a49ab100fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5399ce4bcdff3d28a512f16b6b37cbbed6d51c61addc1ef94e39be5ab99b3f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c626850d0da60c14a0bff1ae4f6d6acc55607cdc84d6b430e1b2a682075e09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
