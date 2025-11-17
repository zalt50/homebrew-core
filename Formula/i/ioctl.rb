class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "eb32418e9a83225c54398e984a20d58e1f2374522ae4001d518aa206e85713fc"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86905277858d4276180550ed9c70867d14843963b87b45d55cb93edc5654928c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d8873b95811e9cb55bd8cbe9286858b6fdadab9cb905d4649332f87b7bd702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255b9ccaa3f1f6d97b58254ef88f669763b38015f1bf77384219430d5f9b9ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a0151ddaf87af2eb01542d291ce05940e4189037d13695f6132cc904588754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cc8f45adbdfe1be8fbae37404326d225af57de4a27abe6ddf559cc4923373fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f07ae3f2ea3fea2000b411e829aed30a04f8b64e3a9236cb104e02f751256f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
