class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.728.tar.gz"
  sha256 "14c5511932a5a0e79e194c3da57b13343dd94484c7f08f96a19b19d6d1bc5282"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5541c69aba9c8c30333de9238356619c4c9a6e429c52d5a49dd6ca69ed8652c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "281badfb53fa87c0451eb084daff8c12516c7c0dd55cb6b6d2db1fbab1c28311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d32eb2c76552103ce435963ec5c992349c50581f6e0f8134c401ee381f4a331"
    sha256 cellar: :any,                 arm64_linux:       "1d8d515c07f08bcdddded0a1f75f4c33dedb5d91cac3cde4c22b1a8263b630db"
    sha256 cellar: :any,                 x86_64_linux:      "7d7d8720e805a220517416ce4bb1ccd09391ca054ff908b5d4c7589a300e5e15"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
