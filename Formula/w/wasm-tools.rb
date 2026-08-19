class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.257.1.tar.gz"
  sha256 "875dfba79df2b09cd4eb6944a75020963a04ec109549de7652e3513971d23971"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6c6d6e81b337027039b61da467037f3c7e1f13d85bb961a8c0b869ce87652f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101af53ae48f10354b46da75017f163b602d23b3bcc0fa1f9d0901df4129d437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f3cc5ea9eee7edc08c90883525b9c6d16c994ba1e9d877911fb3043caf9609f"
    sha256 cellar: :any_skip_relocation, sonoma:        "448fbfa14ce247cda247115c765b5022ae13eeb96414c79afaa401be6773e620"
    sha256 cellar: :any,                 arm64_linux:   "34567451bc7e9e68ca8518dd3a018915080a5c13900a1760afa7dad37ef26a66"
    sha256 cellar: :any,                 x86_64_linux:  "f19711feaa0fcb96254eb60be6b495e72bdb3c99439c95521f842bbc3a8c3378"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~WASM
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    WASM
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
