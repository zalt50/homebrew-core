class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.12.5.tar.gz"
  sha256 "4846510eafb7936410ff1317e6999686f9dda6ddb4a27b5a8d7dd62dfadc9555"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020f24ce6148ff764ccfb286d7e7074eeea4e60a1a522ce374420b238b83384a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d95c00a8a600cb0f76c257d49020e33ce74d1c35a25c2465d3c2fb7311a71a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94a341e48e57a7832c51582872030089781c92e4218ebffcf1a670d301532265"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc319362a3293993bf93b099bbdf0428a4f89bec2fe2fe8dcd705183b4776b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957b5efad4326cccd8cd0b323e25c725f93f06922bb0930e3e2d11823d5da0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "019b9c1373738d3fd41373c7320e1e11f42a33c3b084a44979e5cd404cd7ad95"
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
