class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "b64660a4131d10efa14b9f2122e1c113d2ce2240e7ae68d7f62dc7d4780d2909"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5514ba905951dcc0223a8e4bbc3cd0ace67041b3735924f7dc4e1aff302a2c79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35650ad278558d2c1e81e66112ec1369b1cdfb7bdcacb0bd1576e99a1115655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de193a93bcb26544b44bebfe73d6df6c310db8a3bb6570fb395866a7b459f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2034c32915c5d3eba875d0fb0aa85992542872068376ee3e5ef5a4438f2d0196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b8d6d3b4a5ab23322ca984657106fe7900d54132c626cd82ad0e948cde6aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce97802d81c8f56007b491acbd2a099cce1a79046c2f499464b83ae101fefc5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src-tauri")
    generate_completions_from_executable(bin/"cc-switch", "completions", shells: [:bash, :zsh, :fish])
  end

  test do
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/".config").to_s
    ENV["CODEX_HOME"] = (testpath/".codex").to_s
    ENV["CC_SWITCH_CONFIG_DIR"] = (testpath/"cc-switch").to_s
    ENV["ANTHROPIC_API_KEY"] = "cc-switch-test-api-key"
    ENV["CC_SWITCH_BREW_TEST"] = "1"

    output = shell_output("#{bin}/cc-switch env check -a claude")
    assert_match "ANTHROPIC_API_KEY", output
    assert_match "cc-switch-test-api-key", output
    assert_match "conflict", output
  end
end
