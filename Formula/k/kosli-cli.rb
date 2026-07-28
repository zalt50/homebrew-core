class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "3f092ea3e5983baa83b4ad1185338f02e726ff17fd2fbc21dd305f3a32a8465f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499600a60e5455833d5b8b82dfa0ee045b09b95a37ecea9f46623c1e8a100f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d427747a7ec2f4694b68b28a060ad8b8d4897d5b6cf1a65c0855ce815b0c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57a390c79e451048f4e0786f04ae7b57fcfa1dce0910eab1a91cbd4367f83b14"
    sha256 cellar: :any_skip_relocation, sonoma:        "3502a3825628dc31b57de6108a039e058c4a272a4a8fad9ee2e0df14d2244557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40df188a268378ba94d41f6252d3380e463d09b02b772b49c558430ee2467e4"
    sha256 cellar: :any,                 x86_64_linux:  "cff1cebe9219d941f7cb36d5fda20a8d025e52e938155ecd9f6195abe69d795c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
