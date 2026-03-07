class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.68.2.tar.gz"
  sha256 "43421f179c7d08fd3afcd838a597ea2c103b0914d14d36805b9969990359c3c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68961539bf3643af37c5940ea91c227d1b18cfeea5a7cd2ee5d4c87607684689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68961539bf3643af37c5940ea91c227d1b18cfeea5a7cd2ee5d4c87607684689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68961539bf3643af37c5940ea91c227d1b18cfeea5a7cd2ee5d4c87607684689"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99d2f7d2f945f903640a0f88f50289b3f5f5ebb26b601b56bafb9f077b8ddcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c898bf3db87042a91c0d666c75d23f1247c48f246f207de00a976ea4c5fedddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2712638ed4a4cc43dfd73ee066c595c8f53f3ffb94181f756456ac2e6e4032fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
