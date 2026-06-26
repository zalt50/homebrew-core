class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "79eface5a45e0c5e35ae2f8f1c38c4656d717d839180991a4ff63fdf127bfa67"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "060fcfb276e22536dd8490640d4227bf34c646877c44341f66fdf38ebe3f601c"
    sha256 arm64_sequoia: "5875651ee8881228605148bddc5eb60f3facaf1200c7b1c8278219771abe9f53"
    sha256 arm64_sonoma:  "cad194952244f35e85781bfe2a7c3bf140d11a8ca3f97dd48df4ba7abef5e4f5"
    sha256 sonoma:        "bd2dc6d13ae69105542521a496841b3c9a28fc880005e783c37e53049c916f67"
    sha256 arm64_linux:   "4cf60eb6aeff8dd14fb6bf4e63ed3b2b6c3dfe44374d4d5e165cb37b83b6add1"
    sha256 x86_64_linux:  "48e9487549d500279ccd53f4950ef135d1497c1b19e70e6fc3fda2cb47cd31ea"
  end

  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test
  depends_on "rust"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
