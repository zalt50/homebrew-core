class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "9b4c9e5992c185af4b3260b4a805309e599efbcc74f406536c28f9beffa200e3"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0b742d266b367898a89425cae20a1ddd8e2aaf39fda45421b97c6b3253fb69f"
    sha256 cellar: :any,                 x86_64_linux:      "2ef31bc97a96bca28a65454bdcc7dd67bec114f44f6c61861a78c31370b4e0b9"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://github.com/aliyun/aliyun-openapi-meta/archive/ba3c757837b8f60f4890486b8ce0c9672bf37268.tar.gz"
    version "ba3c757837b8f60f4890486b8ce0c9672bf37268"
    sha256 "266392c0ec0e71550ff52c636e2c7f5ef3d26292f425b404dd606c4ddafd4b09"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")
    system "go", "generate", "./bundledmeta"

    ldflags = "-X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "-tags", "aliyun_cli_packed_meta", "./main"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "Quick Start:", help_out
    assert_match "aliyun ecs DescribeRegions", help_out

    dry_run_out = shell_output("#{bin}/aliyun ecs DescribeRegions --cli-dry-run --region cn-hangzhou")
    assert_match "Endpoint: ecs-cn-hangzhou.aliyuncs.com", dry_run_out
    assert_match "Action:   DescribeRegions", dry_run_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
