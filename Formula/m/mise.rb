class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.20.tar.gz"
  sha256 "85c634336f6ec13880376ef2d96c7656964cc61777a1dfd9be9c0499b9d7a143"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeb6edae84090c882dd7898c62412b313eb9264130fe5501d1db64bae6f3189e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc82480a16a1e332f6d7fa8936d3f4185808a57e8a7316697dc46b30b517b3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6091e9ba81f675129d3e71d09f2df882bbc1c462bafea157f6bc462b4cd74e6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "647fec03ad0c23762d660cc539f74695c54d7d95ff74cd97bfe7b169390a8854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e00506aae90e45308874c3828daa055d42d07ec926f9557396667f90322d978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20104e3d0c301543733fb48cefc6d1bca5660edfcdb90d5327a97b60c179db5"
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
