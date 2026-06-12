class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.24.tar.gz"
  sha256 "5ec73ef6e0631458ff3c1ae2748e5d06d12dd43edb6da49d2a9f505df90fc5f8"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f04b1a36bec7b567fbb1b4b15576c77b85f1e3eef7aca9389d7b76b21dbd5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9f3a13180bd41ac284a7b919ce08b614d6202469b495380d0a6ad581019788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf0c49f4eee64164743608c765722be80d74fd34d079cce59480a8058165b756"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d3f845c4795337f496ce2eeeaad752f66875ceefd392a1faa374fa517cd948"
    sha256 cellar: :any,                 arm64_linux:   "612003c34aa9ed35f8ea9e7438da7acd67f1dfb92b6be8d2e7be96728766f80e"
    sha256 cellar: :any,                 x86_64_linux:  "fde3e3637146d9544388ca992047f3989aec0bdbda9fe1d2ff199448b8ab20ee"
  end

  depends_on "rust" => :build
  depends_on "lld" => :test
  depends_on "llvm" => :test
  depends_on "wasi-libc" => :test
  depends_on "wasmtime" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "builtins" do
      url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-24/libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C

    clang = Formula["llvm"].opt_bin/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasip2"
    (testpath/"lib/wasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end
