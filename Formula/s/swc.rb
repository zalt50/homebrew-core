class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "6ea9c4afbc560a77a9f8d8fc66090b8868027bf4a346e13a92b0b3ac17f2e111"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca119b5e96a7f5d06c738bc9cb7d4ff483c294916b71f6baac26d5ba308711cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51582fa8e7f1a6039bdd0497e9018c80423025ac8c0d92921da343626ea4515a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "392a97a918310c45319fd62aa9773d49825e14410fe2a5b770d81b110062ba36"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a507f2171e2335c699eae9d76fec4c7b9584da4a56c50a89d5ec85f3e0cd34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d657f5ae82f017e5deda2365e0f5afe13fa9332751961317390e4becdedd2643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1f490b4b5200bf6977eebc58805128660b45feac8bd537d17d40a34802adec"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
