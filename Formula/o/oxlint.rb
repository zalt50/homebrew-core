class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.39.0.tar.gz"
  sha256 "9e5ec2a5c78edb624d74446ede0c767423e851fa88cdc7981db054bd4997e7cd"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "392c505f270a9e6be128abaf7e954e0efd2f7ed408d6d76cc4ddaf53d7d13137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9951a0e81c66dddf1bcf2137a5cb457ed6026ae6e27537c86d68ba6cca127216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3555fe76cd3f09a8150a09e1efadb3d4cebdc30f0d4c320896085fea13be21"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4ff8f3da14003732313efbca7b3cc8a300e8d45838762405d9bc95399fdba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79edb6041831033ab0b7c8dcbe52e9bd12678b717064fbfd4f23196ad0a1969d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c5987dcee8d1390ff78076b73ca0f65a4ba2a9b558e3bde1e2f9f135ded4b4"
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
