class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.241.2.tar.gz"
  sha256 "740ebd8d3dd293ba1a6f94c258cde9f19ed8af43325e24682d2b58367edabc9a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d85f7dfae51eac9d4d6850b46f2eea2e9cdc265292540663d5cd87c3874ed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b63e4ecde572ffc4905080f964baec741fe7fe25b59a11b624696d5e229bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7673e43ab9ac59b70a9a7ae7abf04460f9b4f8e28e2f59128107af2e207c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "73d6b7ed31aead27262db4ada47cc66cbde6dbc91670908d3269931d2bf28c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff17fa1b3ca7823111cdc0690493fadf55009b1516341d274e504f8e304d9dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1fb36f70693aca6444e896757d87907754240a5bda4b6c004ddcdabe1d3c28b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
