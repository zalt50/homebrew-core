class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.697.tar.gz"
  sha256 "69ffedb34c85d7ad855e65e2b28d31cf74e72f26f3fc622b7a00ede1c9f27341"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbb3d4c1f315a46bbab4dc7594d24eb6328d4481f20fc36229e7ec0898645dc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60faa02a3a7d7b050145f00596a4562843d42728ac82425f3768cea641913918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba37f35531594923b8450881ed42dc85325c4f61140703fcf4dedd55982325a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "153b87112940f4d74dc3fff89cd576a4069c5fbc78fac591ef62274dc67e2e14"
    sha256 cellar: :any,                 arm64_linux:   "d805b37d6dcb40295f577c9c9edc2c061969fd7e5f99d7387a782c77d14599b3"
    sha256 cellar: :any,                 x86_64_linux:  "386d778d0547a8195bdf5549471a27e5e9f314d4e8370f60c4c4498cd43af75f"
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
