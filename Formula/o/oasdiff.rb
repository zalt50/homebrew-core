class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "20962c9e706dbdd76651015b61e4577a5fb3febad87e8d6c874d150be99c77f3"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171a2c43f28309d6023d8b0a8a525313ff72fe418f1725bd042540c34265d39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171a2c43f28309d6023d8b0a8a525313ff72fe418f1725bd042540c34265d39a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "171a2c43f28309d6023d8b0a8a525313ff72fe418f1725bd042540c34265d39a"
    sha256 cellar: :any_skip_relocation, sonoma:        "96335fd3a3e7474912842d43bc359ec645b68f008d4aa9aa09a934c67736b3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ac784a27420f423ed129b8b692319b0fd30d536136fed072ad67dfd63229f9"
    sha256 cellar: :any,                 x86_64_linux:  "7e73e539bbfe2a27e761e7109b9580a281a4c6461100e6ecdc01a01e12c256b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
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

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end
