class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.40.0.tar.gz"
  sha256 "c6b0fce80b10c5c999198885d5d7ad711a4295054ec758be82bb69b5409f62c5"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b11a3e63df43637f2aceaae9e8d8e344d79bf028d7c8b8ecbb7452d318ad915b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4920cd23275a2f06644aad83edf8f1978316eaa6a7e32c1844f2ee12c3a4fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f4f9536d75604444d24e11e635f08c7bdfacf536099dbfbcb50d1f4456f1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4e8dbf3b59dca7a9b8a4a3b5668a1b7f3db7a0ad24698e5b1ac2eacf4ffff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2b293285176db5f9e9a1dc5d48106ce2b7f4b100c344e547231d2555bec1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc650b04b0f838e834bb97c4d47298ff1b95a3abe61a931911418f68dbd3b33"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
