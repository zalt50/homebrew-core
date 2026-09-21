class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.84.0.tar.gz"
  sha256 "8b3575460c92014fbe69d64b17b4947839f0a7a316dead0dda7fd3d9826d85d8"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b689986ec6db6d37a27ab0bcb73df6a11c5a01a5fc9cea3de3a00eec50bfaf0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a0f2ff2bfd58fcedb966e01caa6f34c6f8659060b134a9cc565e87239a936dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fed41a38ea90c5722a64bdbefaf658c5c39c0a419ebd5358a753d54733f526c9"
    sha256 cellar: :any,                 arm64_linux:       "9dd3d426c3aa433836c317067330bbfa954ed0304be3001f533dad451aead908"
    sha256 cellar: :any,                 x86_64_linux:      "2c0ba4b0aa8bffce3013dee6a90228e6ab7c63221ca31cc8d38f30477b840772"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
