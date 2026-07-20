class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "90392dbe4bac664558425e1e51c1e4dc421d6ca124756c28d989786f89056a26"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc83c92154f814438cca3bf2f1c0b0c18aacbe216efc6a96f8551c1a9d9fca1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f5fcb76e7dab83d54ddbc476545ccaddd28dda41a6e0fd59e4f11f7986d01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac897718a140eb32aff8cdc79333f45e743ab1cc897e5bbaca89b4a8b5091ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "7432c804f32be49d23ad37844eeaea1ab7de05e5eee3dea240324d55d1d7ca46"
    sha256 cellar: :any,                 arm64_linux:   "704f6407430c873379b42b35e63d32ec9745d15511662ac2639f86e473451238"
    sha256 cellar: :any,                 x86_64_linux:  "1f1a97fcc5bae2932ff7c39cddc3b033e82ae4506dc38a08c93a93262a2dcdf4"
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
