class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  # TODO: Check if `rawfilepath` workaround can be removed
  url "https://github.com/awgn/cgrep/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "6f7be7a24446289421fabe98393d00a46a1751ce1f605d84135e83d0ddf1d49e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52f7d3bb9d8209371249400ffa5c6ab140f9f3e44fa14f84bdff378461ccf5bd"
    sha256 cellar: :any,                 arm64_sequoia: "4fcba62459d97b4b3d889a52f070eea7728735e6a287bcb73b15ee028a613984"
    sha256 cellar: :any,                 arm64_sonoma:  "3a47ba098507366b8413d0207215e2eab9710e1662a74197b321c80e6dda78ad"
    sha256 cellar: :any,                 sonoma:        "b99c98fac686d596beb95f3e40a7c14d90b3ef434d70af621b4da5ad7b12602b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2559ee78b9e6004910f9f2c74eb8d877cc775a5441d39b49abab80edb3c3e87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b86b9d5cc3c3f7a0caac9c10484d904532258db1b58d60ac4155b3160040513"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "pcre"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  resource "rawfilepath" do
    on_macos do
      url "https://hackage.haskell.org/package/rawfilepath-1.1.1/rawfilepath-1.1.1.tar.gz"
      sha256 "43f879da83b7b07c30e76a3c31d5362b7b6bb8e235c2698872b92b9fcce3bf69"
    end
  end

  # Fix CPP directives alignment
  # https://github.com/awgn/cgrep/pull/50
  patch do
    url "https://github.com/awgn/cgrep/commit/72748d85dbc2bb8059c4a4782be52347fc071eaa.patch?full_index=1"
    sha256 "04ecc69ec482f0c07edcc07823c284e93e9822128f0398bf00918a81b08227ca"
  end

  def install
    # Work around "error: call to undeclared function 'execvpe'" by imitating part of removed
    # hack in https://github.com/haskell/unix/commit/b8eb2486b15d564e73ef9307e175ac24a186acd2
    # Issue ref: https://github.com/xtendo-org/rawfilepath/issues/13
    if OS.mac?
      (buildpath/"cabal.project.local").write "packages: . rawfilepath/"
      (buildpath/"rawfilepath").install resource("rawfilepath")
      inreplace "rawfilepath/cbits/runProcess.c", " execvpe(", " __hsunix_execvpe("
    end
    # Help resolver pick package versions compatible with newer GHC
    constraints = ["--constraint=async>=2"]

    # `base <4.16.0.0` is not available in the most recent GHC
    inreplace "cgrep.cabal", "base ^>=4.15.0.0", "base >=4.15.0.0"

    system "cabal", "v2-update"
    system "cabal", "v2-install", *constraints, *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~RUBY
      # puts test comment.
      puts "test literal."
    RUBY

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
