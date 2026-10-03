class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.10.1.tar.gz"
  sha256 "5057cb045a18c5f3673c25f73c3e52eb6b09b64c1bb1cb35d5fcb106942f8035"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd9ad28212d22e1b6082e59869cb418a358bc1aa525784ad2690d91339d3dfd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c029ec6dab9576aa3eb9af4bb0048b85ca282b482ea0ded9c416a86d0d45488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92e759e8657c7db344f6fc3a2728bbe28b638b8d44b163f208d16f4e370bae8d"
    sha256 cellar: :any,                 arm64_linux:       "afadb9d38885d4f3505dab4c2fd6b44f5badccbbaa9c1c254d4b80abd90da4e6"
    sha256 cellar: :any,                 x86_64_linux:      "b3c87c028093fcccdc5ddec0f8eb01dbec6ba2d3c0e5d8203a9c77c6fde9954a"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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
