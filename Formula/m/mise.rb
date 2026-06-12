class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.6.5.tar.gz"
  sha256 "81d9b27a067cf6f91d071b9520a78598524747df1e894f9fcd4d03ae339d7748"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d585a72c318adc0fe4b3dce4b3e90ee771b86ea7f057f4b6747457fe8c90a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938aebe360154f36451022010013d9774a60428f9a643020971defdb933be76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4860e600486dd91849925230b0e0856e2540f290f0274004baabb37b96b94c78"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e0cef6a270e6bdd27e6d260ed0ccbb26d9aa22f1f9f0841ee2d50ab1167ac40"
    sha256 cellar: :any,                 arm64_linux:   "a7e01b18ac2dbda71002c274584027afaf489ebaf9be3812ea5dd4815475e558"
    sha256 cellar: :any,                 x86_64_linux:  "b7f80033723b2cf0808cb93f9305019eab4a8563fba09fbae1ceab435e839fd8"
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
