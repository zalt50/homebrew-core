class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.12.8.tar.gz"
  sha256 "7bfaf2a4c48af5b4e9437f92f77ae8161e8a151e860106280cc2eb1f6a57ba29"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5905cb08f263998136db9cde9113d5a6749b83015e4cbd18f4445ab54f329b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9026491f8b5518ac1876c96b9695074d57d2748cf408bf23f71b95fc063546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9bfcd878c30e3fb115a0d2053e503ada2c19c2698b25834079557308d7111e"
    sha256 cellar: :any_skip_relocation, sonoma:        "339a2cc78dc918e780b7f823153aa6b0bafcab90207706108f7094d6757b1c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5affeda899fdf0279ee6df9725fd1dbba5b5b122cdd27ea8e4fabf9ec2088f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec50de4567b7f2dfbfd67ec4417ca0db739896135da0143a086018377c1365d5"
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
