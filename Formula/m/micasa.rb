class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "060e10299c0f6d080211c15db5fdd557d429d83999d6da4db00ff0901af79454"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc42eb1f5f88645bef81a14e49d10e74c1f2882de00a44397b118fc87c21980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc42eb1f5f88645bef81a14e49d10e74c1f2882de00a44397b118fc87c21980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc42eb1f5f88645bef81a14e49d10e74c1f2882de00a44397b118fc87c21980"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0e5f8c7e1a7d8dda17fe4c001a9248cda8d8bd9533486708fe321b5a8b7a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "196d1485ab56b80de79107c29d660151b5e5d6c9a7033b22ff6accd29c1312b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2278c4aa96a4bc326b1ee8ae5ebfbea5a085db84d2c328823f73ab6553306e58"
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
