class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.19.1.tar.xz"
  sha256 "a3f513e988a6b1c38182478d57f5e60dc6c7331217d22c05a73de33baa553de8"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e0c81e19b4109d0e52e73bc77a97467c4df6988cd62ceb09ccd08e9fcee994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e0c81e19b4109d0e52e73bc77a97467c4df6988cd62ceb09ccd08e9fcee994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e0c81e19b4109d0e52e73bc77a97467c4df6988cd62ceb09ccd08e9fcee994"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b0d2edc4222c7cfd84839948832e5f61976f449b3073ba7c150f0619729eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5577f2c751c62fcdb6af345d864d94b1f755e0dff437d91806e3cd0d0fc7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7140dccebbf6b44cbb1a5d0f0df2a13a45c8adc731ccfa232ebdfd464fcde48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
