class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.7.4.tar.gz"
  sha256 "76eb80e720704c74b1b479b1828227ee94dc0bb9a443996ce098abb8216af40e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "845aa30e31e9b58a61af6d5b1321926d50d012796837bc82452e3dd0ca1b537c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff70ca437b1baa79c73a891e644c6eb0fcdf8660cbe74549d3fefc66c03cf72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f19f7a690f09a4d01069c75f36e02e82d8ec2932de3cbd7e0fc41a5ca179e841"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ce2f5f263bfda9fec753de2e1da8c15635287c778583562b4e2bf0e8b8db00"
    sha256 cellar: :any,                 arm64_linux:   "abac5603ad22a5b881133796ccfd80ea59b2a7929fccf91d919c2e575779e5c7"
    sha256 cellar: :any,                 x86_64_linux:  "6fbb839776a6597c1b16d1c975260370712cee2913e25f3d4e75850e5cf506db"
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
