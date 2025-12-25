class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "e6502d310408d1f4ae8f215abb87b9d11a514a72f5c532175a065edb7f35dc78"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1435233cd39be25a1e796907f9cfa0a8bfc9208b0e9255966020ae9d52e7e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988b1183d624f940b321a291f78fde6fd2c6114d5c68d43c443e3ecd665212b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fddc4863a7fa01c9d595301034d421e24b0287127d4943dd237669ca804b719c"
    sha256 cellar: :any_skip_relocation, sonoma:        "180e5e0e946de3faf0cf83f472beaef028575df23382d02d161a8973c2840816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b43ec842ac0b345c8ea76594cabdb25fa4e325f298e84566b79ff07a70ddac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c184b58c9cf42b0ab0a076b6bde30a0adc8fe3443f38c56de8d732231e39c9"
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
