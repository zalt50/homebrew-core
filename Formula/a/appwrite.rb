class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/26.0.0.tar.gz"
  sha256 "f7c34a71048207a74ceab9168f11f34e6b57f57d2ca58c6d0bfe1b96ebc332cd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 arm64_sequoia: "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a080f2039f7368addad1644b13adfebf4c60d070e712bf645fe49d585b269f"
    sha256 cellar: :any,                 sonoma:        "5875c3a1a5b214313fb5466da43f811f808c997b81310bf4d5ffa6aa9423b96c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36df56f77d98777a954d45d711ddb03b186c0cfdb8a2fa7fa1a499b85aa938e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9e081906aae790a453a2ba2f275c372dc5f44109165f1e8e3cdcb1cc2b0c8d"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
