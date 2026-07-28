class Tpack < Formula
  desc "Drop-in replacement for tmux-plugin-manager (tpm) with a TUI"
  homepage "https://github.com/tmuxpack/tpack"
  url "https://github.com/tmuxpack/tpack/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "15dd0770fead4034320434816ecf315918effbcbe66d38b0e5e03530fe250bff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3a235c8314b8c21b2c129dd97c26771c216895041f8fdcbfa8e6381995dde6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e3a235c8314b8c21b2c129dd97c26771c216895041f8fdcbfa8e6381995dde6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3a235c8314b8c21b2c129dd97c26771c216895041f8fdcbfa8e6381995dde6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fcf75fe5607c4a8accc94e25bb5b7c08fdb3a04e150a9ba0ef4b48c3374580b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f085a8f3e44f662db28153eaef678ca150b0b0562a043b8832dd8d9b038571c2"
    sha256 cellar: :any,                 x86_64_linux:  "49b5bb088e596081ba6147a2a45330273f5b49b2cd077922cd2fd14b15656762"
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
