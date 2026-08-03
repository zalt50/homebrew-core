class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "9b630ed0e5a99c60a11174b5bba51d2c62e038e338fabf52f4bd6e5986b29d27"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51377abd5ee6506127acc95cd17afeb79b5dc90d4d45d0431a55b3833a27a0c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5887b1f6d2dbdbdfda7d8b6fbe245309ef4b7e9d4b14307bd332faf8d01cd58e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25c56bddf6425792ef13efcacdb3913b9381923a783099b7aba6e1a84736c93"
    sha256 cellar: :any_skip_relocation, sonoma:        "eec1bc8bb4c2ac5ea920b7ad5156618cc2f40dfb4a87b3bc8e906380517443dc"
    sha256 cellar: :any,                 arm64_linux:   "63e2bc204bb00ba408309a3b8d79d773d0009103832b99bfdedc3b143729cbf8"
    sha256 cellar: :any,                 x86_64_linux:  "1e36d5554768b39d51a4175ed8e0061c80041407dd6b4b3d0d52f53be968d209"
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
