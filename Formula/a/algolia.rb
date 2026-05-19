class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "7ed6d5cb2d04236de207dc801637819ce543d24cc372b32246ed6a2847d83092"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a263bf087e2888e8329493b03ab7d25ccc4f8480c84ada85914d3245e01655fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a263bf087e2888e8329493b03ab7d25ccc4f8480c84ada85914d3245e01655fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a263bf087e2888e8329493b03ab7d25ccc4f8480c84ada85914d3245e01655fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30411c62976f403c93da05851f6e549bfbf5912178f3bd7c4aafda92d837e2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c254755bc9e179068eeede67381127e2cd9025999644590969f52ba27b021359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ac8b8de9598e0b27e8647ae06e4fc2246fbb0906b3ff5d93bc9fa798e350d1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
