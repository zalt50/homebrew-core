class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "be8d4a5cf752c6e8a772ca45ca11a4c84d0c1c017fa69c4b0c7d944ac7703386"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3011d145b8e2a7aeef09806ea67297311bb6794198570088c7a0fe3a6f1e86be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3011d145b8e2a7aeef09806ea67297311bb6794198570088c7a0fe3a6f1e86be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3011d145b8e2a7aeef09806ea67297311bb6794198570088c7a0fe3a6f1e86be"
    sha256 cellar: :any_skip_relocation, sonoma:        "876a8c89014f88b642d23dbbbe2ef0da5f4da04a83e13493b29d107a2c80d4d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb051d6d8f9e5db227ea0ef226e686146b06464a42734940b0ecb2158b19bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca056f55e437dcc6818b73f7a62715ae0ef7ddf5a93f1c88275a2b9b9297d2c0"
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
