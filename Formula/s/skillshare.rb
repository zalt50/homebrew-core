class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "42fa18a329220a6f26ce4484fa4c0d68581890f5db0b2a0f820b6e4e3dda2149"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15a1e72730083699c28e8fc13e211fcab107f07c7abb27d47411f7962f96cfd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15a1e72730083699c28e8fc13e211fcab107f07c7abb27d47411f7962f96cfd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15a1e72730083699c28e8fc13e211fcab107f07c7abb27d47411f7962f96cfd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9de8f6dbd1daec00f5b6ec88c9149017b4ff78eeadb1e914d35c5850b671056e"
    sha256 cellar: :any,                 x86_64_linux:      "9a3adf6817d2b5bf34a2c59206914caa20ecccb0f045da0c6762aeeff9cdb0a1"
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
