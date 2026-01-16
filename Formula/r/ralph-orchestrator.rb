class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "fcf8c4f6e034c9a60353066cd45a3894218bcee78c015cf5f1caafe1e67d07cd"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
