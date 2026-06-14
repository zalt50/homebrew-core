class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.6.7.tar.gz"
  sha256 "1ec5b038b3b86279ec8118f539b166422ad4a4874f93e71ae478d22b2f70413e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd93e1555295f9f92b1e7d00651a86a3458c97f03fc1caf6a86370b19b981470"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3aab10db97a17ec9a76ca722535443aecffb93e60b7992fa790b65b7c872d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74b7e3042d3bedfb23a07d70f6981a98bba59c4039473afc87b7765f471e6078"
    sha256 cellar: :any_skip_relocation, sonoma:        "15691f82c5856b19bd59b9e71300d3ce2a9ddf821af0329df8ddf8c54ac3f603"
    sha256 cellar: :any,                 arm64_linux:   "301acc08c80e300a1c027011c80775f551200817c4b36d8411aff6266d3781ea"
    sha256 cellar: :any,                 x86_64_linux:  "d527d166d3383ef134c7f230c76b0ebb4406ef96704393a0b4dc1070f186b576"
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
