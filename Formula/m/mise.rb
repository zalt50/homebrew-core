class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.14.tar.gz"
  sha256 "c2b7d1ff258b57b33a33c155d25a610ac025636b8bbe3ea44666400682efbf59"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afa7fdc4895dcbaf352963562c1a2cf8f4ebff2f69c6844b49072cba0d6db21a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9111f797056df8158f7180fa771960f25cc3bb8239a9b6c9140d320900a02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e281ad6b990732e0beb50a354885b7f86c20296db22086a65bff8b9ba49f7f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a6cc674aec9a9ad55481685744e0005163c95f592d22db45a2d22d51cddf3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17158b201f64f63a65e6f4058fb45946a849f1e761f5f579d40b62166124de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3393c090de4b5b175feb5e8840732e7a602a8f017abbef397d6841ebdfdfac"
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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
