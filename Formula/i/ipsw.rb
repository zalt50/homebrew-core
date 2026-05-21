class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.683.tar.gz"
  sha256 "f079ac8c53c02e78567099c85a70a7b886a7f774525f8e0e6211bb26614ea584"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146ed359c414ef0106880012b0efec5571621b23d453a6f75c54ca1f810ffbcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae3d7590ec36cdb30b4a89d877da31864672174f7a55f2c5638a328b45599b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07cd91d75826944c01e5c4b942423f9e674f58ce2e316bf6fff07f00f26b172"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f31593f2f307026dd1e025943684e70a1f0d976b0f88ccb783ffb18dc9eda58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf38483e4285564d58e8998641c0f7e82228d674cbc152a3577c12aab179cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba8c2b60c2136953aff14ddd95fbedf3183cf62ce2ae7a55144bd74380425ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
