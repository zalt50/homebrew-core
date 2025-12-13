class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.12.4.tar.gz"
  sha256 "f5bfe3012c67ba2b406b200ddde24c26ce376320b22bf0f5ef32226996156e5b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2efa6b067b024f922928bb696e0101e4fc88f6226e815fff26481cfe1d6e2a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894bd73d11978b08d36b39da346e83aec0593469a9b1379e832701ffe3dc2b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcefd653b6c69ce3d142f4c7bea0c19aa5f005d823064f84276ec9a9f4b5694f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80d2260e417a535820931e353d4cd376b442a1bef3568c93711ba961f0a0e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d84427139bf58a2cd2f989c44c83b5cdff2d06685b186c23803755f883fde67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c8dfaf6b2314c6cdfee538a48943f6b0c64ed6c0a81e034be63bc7bbe13252"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
