class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "c2496ae2491f1c8b0dfd86cc6cda4ca3f38b44b8b00c6e64be24bb307e999574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c341d468cc8f844b6891f1652f269faeaf50f4049b6021984ff29c8b818a13aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c341d468cc8f844b6891f1652f269faeaf50f4049b6021984ff29c8b818a13aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c341d468cc8f844b6891f1652f269faeaf50f4049b6021984ff29c8b818a13aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80d85ade07cd7814ced2e11739bfb216a9d11bcac547d3cd0a9fe1d8b3c8d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "983de38584d7a166af09c4f387d9dae1fb39bb6d99572a48841589fff965e9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b81159c17c3f0d283c4315f7a82cc5af4e7f62c4fca69ad1a6a5800364a627"
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
