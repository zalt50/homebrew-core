class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "1cd4af8087ac3e5868f3bfbcc8abe89dd846dad668ced2f3555837f8501283a5"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c65223970d9dfbe2d9804b983a6f9f3e1371dd0ade686764bbff652540345e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f4da27163915af3e178f9b85b684a6da1f15d15de0ad56c6cd8719f28cf01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d63d4d51fe4c28d26a8fb001393b9e12c10b2b9f2ee67cc886f3814ef8a241"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff5460b5a3b023c58dca042347b30c6fdca12a9312add8eb90c7d42c6565446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "038306d02d4aec7abd00c0885fb7334c07fde21ba120c5d06cf66523919da42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81557e70d11a18eaf8129c94a2096ae835cd734bd85f1cdb31827cd00f1c161"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
