class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "68a60cae90e0882cb3e1e699bc1c7e64902b632cc30209f60444c8ca8b2d820e"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10684910852553089557ac0aebbfaf57544b52807d5a0c9f0d25461affdc4c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835b9c1e14b69b7cfb9219ecdd571043755e1330642803c7c2b717fb6b12b89b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb305e654733f1089ae53aa33991e01a88597171478428f5b589ee9fc36f1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3686c91b28f4150d6aa84370997d54513b8754ad88f2e6c36b52fe9b09081d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7988f0b34958d5b489f798c7709614b132b7dc241c9daee1e9023d9bbab19bb0"
    sha256 cellar: :any_skip_relocation, ventura:       "018c07fa0fc87d460618f3f9e30ebd6a3f19a56e2a71e65f81b490f1d77ac414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7b90aaa939936c2c81564f1bb99642f941e17f5e911e16ae4ef3a59b0a0da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "956a2adab3aae85930db685da3a1e3d2df78a80756efb7f62dc958718ace1d56"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
