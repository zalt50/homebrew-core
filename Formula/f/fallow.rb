class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.79.0.tar.gz"
  sha256 "91278b1ec69573068f05b5d249608296e7cf9e2aa74376219eff1e7bc9e215a3"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd769a0041f9633c3c1945dc7c808bef2470449af6d2a82b968aed1eb015ea5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dadac3462dff0131013331ff1b5822669281c31f4e12b14a29efc2e919816fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "951ddd9998f6d9e10b64840193adc2e7e9605ea5a30b60122c02033478bc195d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc119c4ff9a8302239f338fb7e3cb90e2827fa6ac739eac417ab88495f7b7dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95135ca5a1b127baf43ccef687bdb87e5b4c47e8ef530003017cd2606b1d3487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b4e65e2e7b8bd7f15f0187d730c2f5ce803edf28ffe7ff4a5d8db15b59040c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end
