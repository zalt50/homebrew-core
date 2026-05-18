class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://github.com/anza-xyz/agave/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "1bd1b7b4eb412d95926ed9490dfbdac787f75a63df13317af7ddec37be0eb6a1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a317082c5b2b1f2254e43ee4eb6201807de9c246ab9496c4fac47b92d48a7d24"
    sha256 cellar: :any,                 arm64_sequoia: "6554bb60f1e0bf8b0e9cc63faeafbdc244d72bf3ab3cfc197a0fd9b2668eb302"
    sha256 cellar: :any,                 arm64_sonoma:  "d088fe004ce885bb382c92da9b83d735cfd813e2a2d86c46d16db39dd206c98a"
    sha256 cellar: :any,                 sonoma:        "e4aeda5f14cc2a31c04bcdaf601dedbfd8975e32189c698b5b729fd616481063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d65635cfe5b9969c720005c49e042470602a9f4df69ce7d3a9d48e710cbf7c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15be27fcd1ea8c9ac0fdc685796c0757a1ef70b62ef782dde9a0a54f4a1e2a5c"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  # Work around Homebrew-specific issue using Apple Clang 1700 (LLVM 19) by updating cc-rs
  # https://github.com/Homebrew/brew/issues/21112
  patch :DATA

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib

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

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=",
                                                                     shells:                 [:bash, :zsh, :fish])
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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 045adc06b4..5ffbb89f1c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1720,9 +1720,9 @@ checksum = "37b2a672a2cb129a2e41c10b1224bb368f9f37a2b16b612598138befd7b37eb5"
 
 [[package]]
 name = "cc"
-version = "1.2.16"
+version = "1.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "be714c154be609ec7f5dad223a33bf1482fff90472de28f7362806e6d4832b8c"
+checksum = "8691782945451c1c383942c4874dbe63814f61cb57ef773cda2972682b7bb3c0"
 dependencies = [
  "jobserver",
  "libc",
