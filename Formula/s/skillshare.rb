class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "62295e9381a9a1e238970308ba05364a318b4df66680b1d932efb9902256039b"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "483b1c835d7590cd99146b89d12806445f8c998ffe1093d38fb57569229e4301"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "483b1c835d7590cd99146b89d12806445f8c998ffe1093d38fb57569229e4301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "483b1c835d7590cd99146b89d12806445f8c998ffe1093d38fb57569229e4301"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9de8ce74db306a0fa2f06619c94e0bd2743f5f655b9c87891173615d4a1a47a6"
    sha256 cellar: :any,                 x86_64_linux:      "1b44d65da6ee6d9ffabfcf5b573ca68c6648d80340f010c1e31714593be6d7f1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
