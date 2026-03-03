class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.77.tar.gz"
  sha256 "829376cedccde0d6dcf242ca22234d8996e64f51c8033cc1dae4819e6b0a27fb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c45b8813553271bfbae374c11f760edd224c37411a5c28482f6d34b132631ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91686db369ac488137f6994c7b5958d4804fc24c1faed6769e8d2fff46380c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5050048a71cba87740e9fc0fa814de334f4fdba524cc9e43bba93543cb7b7cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b22e97f814149dd99954347b8205352da8bfe9b4ee3ef7232d082a7bde36ebf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14cee3d7bc3583ee5de07bb6f4dad3958c643a5cca39007a92d360a4f739027c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fd91806c14098b263c9bea21f199c7a3bcc5b11202f378fffe304d04dee9e8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    recipe_file = testpath/"recipe.json"
    system bin/"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}/cargo-chef --version")
  end
end
