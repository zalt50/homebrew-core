class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.47.0.tar.gz"
  sha256 "72780e809e7b474bb7b355d79efc32a86f6b76fdb7ab833c99bc497b047bcbcc"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eced98d9c6778e979e6b06c939993971fe414f2ce8a20504b8c0fbe698bc0e6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0546985ec23a4560b0503031c27b50f05218835d513a50c4c8c72db0081c0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e74a5b36fc1b5fee06f0dcafc09c6e6ec204b21b825b80eafb9526add4c3b56f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed03143dca771ac4ce7a6f62fd7c6195c42044921e5b292b772a6c3acff8081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebebc8330dfc9f7f98689cf0f5a50b581a1932fd66754ae0e5adc94e60139265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469ef0037d174e11d1f44adf5d9bea80b39cbd2ecdbb90f6ed4f7ca61f2d22a9"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
