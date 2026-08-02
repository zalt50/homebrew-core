class Tytanic < Formula
  desc "Test runner for Typst projects"
  homepage "https://typst-community.github.io/tytanic/"
  url "https://github.com/typst-community/tytanic/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9acdf96fba301efb4b92cf5b67f6a2b454315aaf3aea79c0a68a13644b2881a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst-community/tytanic.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tytanic")

    system bin/"tt", "util", "manpage", man1
    generate_completions_from_executable(bin/"tt", "util", "completion")
  end

  test do
    (testpath/"typst.toml").write <<~TOML
      [package]
      name = "test"
      version = "0.1.0"
      entrypoint = "src/lib.typ"
    TOML
    (testpath/"src").mkpath
    (testpath/"src/lib.typ").write "#let hello() = [Hello World!]\n"

    system bin/"tt", "new", "hello", "--root", testpath
    system bin/"tt", "run", "hello", "--root", testpath

    assert_path_exists testpath/"tests/hello/ref/1.png"
    assert_match version.to_s, shell_output("#{bin}/tt --version")
  end
end
