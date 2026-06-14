class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.6.9.tar.gz"
  sha256 "e7a7e432d7a3cf9bfeb296368c03cb743a630f246d82745fe7721aa66f130fc8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b699e5891a87687318e24f2959f19445de9a689784f70baf9f79c45808b2550a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f133b73d52f6594899874461ecf630712128a4e5148484d3e9f5b0f1b186809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98436d2575c6ba96c7a7ce921bdce1d290d820903435fb4fcd5f3b5e9ab2e0f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3eb8a970df9e7d661ab42117df0bd8e1dc33829aef210fbb9698d88b6a7b2cc"
    sha256 cellar: :any,                 arm64_linux:   "37146c2851b498e76852e70d945c85d24785a896d9c23a04d2c7fe53f09dc8f6"
    sha256 cellar: :any,                 x86_64_linux:  "3294b2527fe389a0a4f0ce96f367553b957fc07afdf636fe376edd73c4487471"
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
