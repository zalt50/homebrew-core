class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.63.1.tar.gz"
  sha256 "6bd5bbb895e78782bc0cae46f93b81fe6e308583048b84dbb6991af6a3e06343"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70738e94bf518652937c8bce51fa663f23848e0d33141698d9008da6300a1f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70738e94bf518652937c8bce51fa663f23848e0d33141698d9008da6300a1f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70738e94bf518652937c8bce51fa663f23848e0d33141698d9008da6300a1f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "4be3f89ff1239e0b947995f2b942659958f5c8a0e4b066b91ddc2f62c3c0927a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e67a19f6ad5bd7fc58f1e4f444fc143b3ab8fd280afa6c9f76efa73dcce9b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724fab4e2dedaed2a2891a7a4fa83bfd99c245e377e429d9124db01f573c9f5f"
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

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
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
