class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.7.2.tar.gz"
  sha256 "6b26478395491f23c307cb82bc3748847ee6e635abdb3dc2f256e7874389b655"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f958cb0a33af3e25021ee19e0574ad04c34ddeca8dba99b9ed5f5927ecacb35c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460198873f1def9492b6ca2a668f9aef29647638a80a283a99e473d5c44893ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42077fdb4b1f963221d430ad8ee5ba5ccca81155feecd1a8cdf82adc7b1fe415"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91e737338b38cc170b364c4f038c4ba40189cd1a03371eb8e9976c7d40d4a12"
    sha256 cellar: :any,                 arm64_linux:   "2681ca8b8dcb740f3adce45aff43e20719ed3ea10dadc781bc7b5cd9adcd1bd8"
    sha256 cellar: :any,                 x86_64_linux:  "df786067049d1728e7eba5c50e2060c7611a9fa54d76068224a48056380b0946"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
