class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.11.tar.gz"
  sha256 "8af66ef53f4cf44558b67fa32f59e0bbf6b47be7bdf4952feb52eb9ffe57757d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d66c5960c84556b1f73eb7f43f5aea311cd49b3a3f0173c7a816fe79827d82b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d66c5960c84556b1f73eb7f43f5aea311cd49b3a3f0173c7a816fe79827d82b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d66c5960c84556b1f73eb7f43f5aea311cd49b3a3f0173c7a816fe79827d82b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c427c52dcfa98b10c56dec0c73eba190806a506ba5e814f03002dba906b6c8c"
    sha256 cellar: :any,                 x86_64_linux:      "1749d238647521a3d278d040c5be900d702d9b5e655fb9cc47e591b62e5de2a5"
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
