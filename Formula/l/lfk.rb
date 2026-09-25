class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "e34a04fdc226feb4ea0ecc95a394fdf2540d22ba1fa83d29f518c677aab03b0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98a1c1bb81ce607a369a744c2bd932efd6e6c2162d13678087bbe6e52cd74353"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6d1e6a28e2510275675812b07f1b7c249450d54ff67fbc4be6e15aebe1b0934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e909a9804d891df8fda146573dffee8edd8ff732a9a4160605a22ba8434b4c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ad6ab72789843977c599251f5f76676ed2d09a275897976ca38e8f591e63f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a7f93c20f31f5f8e45a040c875bf7f9b2f1b93dce922d01681881179a4177c65"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
