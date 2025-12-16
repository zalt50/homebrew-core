class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.12.10.tar.gz"
  sha256 "6a1c0867558f283b51081f17a2e6961df25af33f94ee0cf88498b44dc8aae5f1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c934c3174183ef40f2741b1a030acffc4f8dd972dc7449f1eb7769a82115f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8b4da151ab791554e82ac5f1c8d757fbb865bf295d778749f61a2c8c8354bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7efb05413acdf1872740a924bf327d2d441293262fcdbe8c53e08a6efd5dc9d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6f4b8affae38a151c8c1f3d82b141721d592c3148695d672c4038544ea8686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8972bb3d3d8235328f175efef6e46228dda622565f60886c50bb099d2c62de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d030c3659e8b827c136d59cd45e4a02f14476e569af5982435571c46bed970"
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
