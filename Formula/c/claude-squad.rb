class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "3ef6ead7fb78fe73fc0a4f2d12d49c5c3224ea0fa9116681a21bd4bf63a58f57"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90cbd80b298afd441defb1da944303155f57dea72037c2573d4d95efea900108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cbd80b298afd441defb1da944303155f57dea72037c2573d4d95efea900108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90cbd80b298afd441defb1da944303155f57dea72037c2573d4d95efea900108"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f3fed37e3eb6ef5f69b8511d9fae39a2239ffb0a82dd97165ebb2de3283c284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e3a84b9e1a183efcdce56f611d4855eea586486bed0c09993faecd55f97d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23d1907017fa5c54fb5e660975965960ebb7cb268a7c3cd5304f4ea4099ea365"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
