class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.14.2.tar.gz"
  sha256 "a858800d066f47e101c9b613d04dbc3f3d6d2bdb932da92f37c1ccdc79077337"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e5d320cbbbb7e69af88b3336419fef1300f6533d3cf0681446bd4dc5fc115b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcb56c53e49fea08a2ec6af57dae05a0a619238ee74d81d232c3cc154ffdae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f234fd924889af3d16deeb4db3531f0fe978f82c971ba6d0e9f995f0e800a5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d746cfbab04df2582234d67eca27d2a6be15b5a9c31c391a6a775448193844e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b2583e54c1bd7da75aabea5b82e2247ae45648a4256621852f22dbbee5d81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28dcbc87969e792495a32fdd21f244ec98eaf4f145ffa9b315143c98161a843"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"main.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS

    assert_equal "Hello, world!", shell_output("#{bin/"rune"} run").strip
  end
end
