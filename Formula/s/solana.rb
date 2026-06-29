class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "0078be7b61bcd38956f4bdbae0ec16eba92ef0db99c5ae502cf2f2a3897938cc"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f85ca9b3d63593de7c5bfc12b41167c92a261d51fd7f70731fe54a9ba5efcde8"
    sha256 cellar: :any, arm64_sequoia: "bbf5b1ae8f71ef5b7c7406184844d5e265025317424a984c13c4d31c967e16e4"
    sha256 cellar: :any, arm64_sonoma:  "ae23403052d77f7c03440fd3df55456d1cfb1f469b985b2fa10c0e065d730443"
    sha256 cellar: :any, sonoma:        "e4465b5a99dfbdf87c67bc8ec05ba6aa5379465c754813aaa5225b8b6d9f9a6d"
    sha256 cellar: :any, arm64_linux:   "58068c641c11d3a37b19ea9c6cf3f8e1ae23374f152a2eabfde94be5e691e97f"
    sha256 cellar: :any, x86_64_linux:  "5fe435590140b451deacb53455807ce265abf07a6210ff08dcd972a887288bf4"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")

    bins = %w[
      cli
      keygen
      stake-accounts
      tokens
      validator
      watchtower
    ]
    bins_dcou = %w[
      ledger-tool
    ]
    (bins + bins_dcou).each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=")
    # `:pwsh` string is "pwsh" in the shell_parameter_format,
    # so we need to write the completion manually since solana expects "powershell"
    (pwsh_completion/"solana").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"solana", "completion",
"--shell=powershell")
  end

  test do
    output = shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match "Generating a new keypair", output
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
