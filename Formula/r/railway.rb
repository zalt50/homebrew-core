class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.56.0.tar.gz"
  sha256 "9536f1262ef75e23071d615abf00ecfb0a29570083aa288a40d50517242f824f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93496efbf8e3002efc145d59cf152d7eea85d9a09c1996621c2d2d4b2d2133de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "619e438a2190ca282d342ae88a3aac3a44b57cccbde74819cad8dd7f2f1ca6d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e31994e24d4295c4a2c308d304f6fc57da67fad28dba66bb3893fae1a079fdda"
    sha256 cellar: :any,                 arm64_linux:       "2204d8af33687f3ed09aac156675f7365276e5133020e88fc0b9b86b6b7295b9"
    sha256 cellar: :any,                 x86_64_linux:      "6a5c9a8cc32d9b41bcd73a5db2728bc0288e61d94e69cce324e1930aa51a4f51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
