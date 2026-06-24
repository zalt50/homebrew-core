class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1cce5cc1e32a140e35366fe819fcf17a7b278338f67073d7bc97d4fa7a2a4d4e"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/compiler")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slint-compiler --version")

    (testpath/"test.slint").write <<~SLINT
      export component Test inherits Window {
        Text { text: "Hello, world"; }
      }
    SLINT

    system bin/"slint-compiler", "--format", "rust", "-o", testpath/"test.rs", testpath/"test.slint"
    assert_path_exists testpath/"test.slint"
  end
end
