class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.3.2.tar.gz"
  sha256 "e8ddea54c706eeae68f36f8d69b3bc6481d1368df30bee11f247d8427fb74d37"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2037b8392bb9b73500f4a1e351cdee6de177b849b3095ce38e32fe55e09591cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229e1fd9d985fd7a5694e9511b2916fb88e7919687b3f048a67b5369ae027d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08c2b5b49a9493d1b08c268295070db3ac17a868153dabccfd99c7e9d9411fa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e0b5f0ff8dba3d0c7bfb8fb907e96c2c1be09d11cdf734be0998dc73ad60e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229d16d5452ac1b20c671c708eecf1e53ca098d9f6f3cfa623e0a8c04926e449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f75973b9a87df884c53ec6a70af7759c80ed03f94e11486bc84b001a3a4ee2"
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
