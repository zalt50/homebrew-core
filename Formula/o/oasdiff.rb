class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "fec45be3052d9940a9ea3aa22ec7ee243d01138a6abdfb3be11814bf2ce4b2a7"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a90cfa3a23681778f496204dafc4690ac2a1c02c4f851b1e08a37a881b09e726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a90cfa3a23681778f496204dafc4690ac2a1c02c4f851b1e08a37a881b09e726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a90cfa3a23681778f496204dafc4690ac2a1c02c4f851b1e08a37a881b09e726"
    sha256 cellar: :any_skip_relocation, sonoma:        "22fdd1cfc98d3a440ede80975bfe3bfed9b8aa09e495bc8a8943b31d7e61d2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "092b0bb28d449056fd8c4869d3f7317fb9554df5a014631b440f7d626a86a9cf"
    sha256 cellar: :any,                 x86_64_linux:  "9751fea5e925cf78987b6a8447fb882bb252f85850015e835849162fc2277567"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "3 error, 2 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end
