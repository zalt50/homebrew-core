class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.96.0-src.tar.gz"
  sha256 "e90a9eb153b2948afac840dbe9d77b64e376706f2864387ee7717f7450043b44"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a737b434cf0308a7d5b8fe96a84f0f080d6fc7254e99694d7bf2761120baf90"
    sha256 cellar: :any,                 arm64_sequoia: "95b1bdf39a2d43f2dd8ce87882af6b7db5554fe5510e3abd61fa215752092168"
    sha256 cellar: :any,                 arm64_sonoma:  "f67006422b732a7221d95f21f7c91e1cbff22286476865e3391ecd8450236845"
    sha256 cellar: :any,                 sonoma:        "2949815437bd707921d9cf7f7d5343697933a0e1f1f81a54bd6d03168195d9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec45ed59c862c29641ce18338ceb3e37100b8afc40271778e7eb848af267470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5760cd41400a3f5b9e0b5e96d1e7f81165be8ee78ad03ac6ecd5161c0477e58"
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  # Required by Rust, see https://github.com/rust-lang/rust/issues/39870
  preserve_rpath

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "149e85a285b6eba58eb6c8bdf7deb1b93763890598e62cb635a712e3a8454f04"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "33db457715446a69ed6f69f78f5fbb9ca8e17a16585d1d7a0060479bfe4c7afc"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "0fe3689eeaed603e5ef24572d11597d3edadaefd2cb181674ad621260f2501d2"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8426a3d170a5879f5682f5fbdd024a1779b3951e7baba685af2d6dc32a6dfc15"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6c2ffed8e1ac9cf4dc9e80f282a869a6b237a153e7c55cca039d33de29d80aaf"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "e2e1131ade2dddc0d779e0ab3a6a990085c7a654951235742823c3a1ce0f190f"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7c070aeba9bbf12073646995a03f36c346bb5f541d0078ba6d9dc2a7adaaf6af"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e74edd2cf7d0f1f1383b4f00eb90c843750bc489e2ccf7214e6476678a907425"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9b30089b0f767cb91b2190ffec55a9beeb2a21a1405d8da0f664d7e09d08e6d8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2be13c14122b8d4d09b7f7c434fca9ae7215ec72049944189c88c4d9128ce504"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "3a21b271b1ff973b94d69b25e7a39992f9fbcae1ab6d9475844a23e6ad3908ac"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "047ea7098803d3500fa1072e9cee5392697e21525559e4458128a2bf874aa382"
      end
    end
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      inreplace "src/tools/cargo/Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
    build_cache_directory = buildpath/"build/cache"/cache_date

    resource("rustc-bootstrap").stage build_cache_directory
    resource("cargo-bootstrap").stage build_cache_directory
    resource("rust-std-bootstrap").stage build_cache_directory

    # rust-analyzer is available in its own formula.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rustfmt
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{llvm.opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    bash_completion.install etc/"bash_completion.d/cargo"
    (lib/"rustlib/src/rust").install "library"
    rm([
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ])
    return unless OS.mac?

    # Replace the renamed llvm-objcopy with a symlink to make sure it can find libLLVM
    arch = Hardware::CPU.arm? ? :aarch64 : Hardware::CPU.arch
    rust_objcopy = lib/"rustlib/#{arch}-apple-darwin/bin/rust-objcopy"
    llvm_objcopy = llvm.opt_bin/"llvm-objcopy"
    rm(rust_objcopy)
    ln_sf llvm_objcopy.relative_path_from(rust_objcopy.dirname), rust_objcopy
  end

  def caveats
    <<~EOS
      Link this toolchain with `rustup` under the name `system` with:
        rustup toolchain link system "$(brew --prefix rust)"

      If you use rustup, avoid PATH conflicts by following instructions in:
        brew info rustup
    EOS
  end

  test do
    require "utils/linkage"

    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~RUST
      fn main() {
        println!("Hello World!");
      }
    RUST
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }

    assert_match <<~EOS, shell_output("#{bin}/rustfmt --check hello.rs", 1)
       fn main() {
      -  println!("Hello World!");
      +    println!("Hello World!");
       }
    EOS

    # We only check the tools' linkage here. No need to check rustc.
    expected_linkage = {
      bin/"cargo" => [
        Formula["libgit2"].opt_lib/shared_library("libgit2"),
        Formula["libssh2"].opt_lib/shared_library("libssh2"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin/"cargo"] += [
        Formula["curl"].opt_lib/shared_library("libcurl"),
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
