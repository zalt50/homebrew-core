class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.11.0.tar.gz"
  sha256 "ba05a29f720ed5b037cf089ee2b7c7c211f225a5649cf695b24d2015893dd495"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7412a6a86c810161333cd9a3f050c252a664b372d4e5c24e0f75a0806b4a8455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca5fdd1ad0a067656d17da5f641764e589b4c6f37882c3e1f0f42e6009fe91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3464a08e01bdd2d85367d1aca0efd3cd5bf824dab9af4ab8a273a6750e0680"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaa06905b40bd74831c4d773188e071f63ba07387bfb8b07b0227203403efccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcd624a9300a24e96e4dbb85260952210cb831678a52aeaf9fb861c99aea2c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5cff3e0737c7e19c9335ec3f9c3e0c65d737bc90a929ea9e390a38c4573cd13"
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
