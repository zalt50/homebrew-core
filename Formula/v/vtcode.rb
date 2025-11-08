class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.20.crate"
  sha256 "9b4d306e41948756ec6891ffcfa48f4da79a396b4bbd3469e54232bb02d58447"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e08930b99dbb18d7f8a45808b8c2ec569a9e3bf07c1682d5866e28c173ce5660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbbcef7aa5a5836ca0db5bba7a85af32b63e28a5b82b2586ca2973c0e5606e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8609ad15a3b88728fe47c3bf4dab2afb2d107cacf86152e8348da8ff429bf6fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c468e5bd5eaee645735f4d7a007247072acc41267a72b7e1db20da7908368175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16e31ef772171452ba16fdb9610a2f46e107e4fa1258d86287b0303fd60ad75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70a56e6e74b31592a5aba221d173e767736cbeb4142e4d5a9c6ef3419396e15"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
