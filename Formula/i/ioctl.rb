class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "230e7485d61aa1cfa29f76702ebe1f1e017b32ad647f3bfc8aee4da3d0a68aa6"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ded4dac81c6b47a284b5f0d880d5e5ab13dc94ac22d5823870d80dc7961f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0960595a6181b57e31408cc00665aa001c51bcc92bc4603dfddaa9b5b4654557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38fbe95692b3c76bc60c10795ab5e61c7a5df129c605b9e578066a6ca92bc5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eba31ad8024d9b695f9539649014077f717630fa358237bfab90fa71b0b7c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17e7a54cf16baa2e1cd2248cedfdf62b27b06e3fab96d8f2c34f0d28aa84833"
    sha256 cellar: :any_skip_relocation, ventura:       "8ad60dcb2470cbadba8c0924295bc5f25b161bce995e65a46cb2cec9d15e3f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f902d8a17877bc82515fee68f3ef4689578618b51209f9e78ec5c9393f54c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51459ccc0644bbef1cbfb741ada5215b6b65e4e34accbbbf6f2a038e302e2d11"
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
