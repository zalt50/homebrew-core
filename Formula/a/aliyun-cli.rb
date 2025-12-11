class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.2",
      revision: "0924d7676eb0ff0cc602a0271f3938a8d3dd4520"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d33af3d7d765cc6bc8bba404f7b91f1baafadde4a48582334cbf6eba99f5cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d33af3d7d765cc6bc8bba404f7b91f1baafadde4a48582334cbf6eba99f5cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d33af3d7d765cc6bc8bba404f7b91f1baafadde4a48582334cbf6eba99f5cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "278bdc876338129433776d3d75c02aef54e7447221b47792f3c1313c82ca49d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a781797891dd487c1221d5a6a46756758f1c49752d48d10b753ff1a077459207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62be5b00f078d2d4e8b592199cf2bfe950792a740c0918f25daacb9fba1b2528"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
