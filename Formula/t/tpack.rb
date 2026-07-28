class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "8ef0854e7ca5ab53adcb259d8abb98aba1f3b8c2a859c15023c032309ba4b314"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7214b24e4b8619250469a67f71dc7c0c7269f0bbba042b866a8678308be0a1ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7214b24e4b8619250469a67f71dc7c0c7269f0bbba042b866a8678308be0a1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7214b24e4b8619250469a67f71dc7c0c7269f0bbba042b866a8678308be0a1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "de330fc1d3be7472f3c5c350af8a7c47b89463e7983721279fbb5b873e1cac7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d8173bc4a5add8f2cb0f39a09425901483ef94f2f15ad83e226c961aba74c45"
    sha256 cellar: :any,                 x86_64_linux:  "192c166765299a4b7aa0eb64f182105464cba4cda90bb8169b51c56b206d1eab"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/tpack"
    generate_completions_from_executable(bin/"tpack", shell_parameter_format: :cobra)
  end

  test do
    socket = testpath/"tmux.sock"
    config = testpath/"tmux.conf"
    touch config

    system "tmux", "-f", config, "-S", socket, "new-session", "-d", "-s", "tpack-test"
    system "tmux", "-S", socket, "set-environment", "-g", "TMUX_PLUGIN_MANAGER_PATH", "#{testpath}/plugins"
    system "tmux", "-S", socket, "set-option", "-g", "@tpm_plugins", "tmux-plugins/tmux-sensible"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tpack source"
    assert_match "tpack #{version}", shell_output("#{bin}/tpack --version")
  end
end
