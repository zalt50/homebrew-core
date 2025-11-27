class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.11.9.tar.gz"
  sha256 "3e60ad1847275e1fd737a49765255c2ec7795063f0b94c82cb6f116bd5d46e96"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acbca5a82414344fe0c97d5b76354f0fbea72969b40c291cffdcbb9cf6db4c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd3bc3dfe822d1481c7dcfb0b08ebcbf57ac98f1c0113c08a94b87f26bee70e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a5cc7c12913714bdb163a030000c93dfc155618a282536665a1f3bfb2c0202c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8efae560e50a2cd864bf4917ce5cac105fb6db57fe2b6afda0d73b723cf4e47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e622684630d5002ece43ff9dd6bb3657638ea8f9a25ac0ea4ed735797e5ab940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0043615d61864238d57aed6997b0b6580f9e8d827e8a8cc938cb50b98af5f595"
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
