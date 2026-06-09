class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.90.0.tar.gz"
  sha256 "787d4373095bc728e0b359dd139b22a77760074387db635f802e472d46d207e0"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f39bac1f841d502f3d79cf3c63eb0eacdfc0a3dd35a6cdd0b7ca851a1908fb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c30cbf0f2f6e3325be8dcaaba1599c879a8f16dac05a87cc470d30ed531e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17543d854605095f9b20a49521fc8926abe282a4701a52c6c0acc1f17c3b5e3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2f2e2ccc2f441822a249cef18021b8b6da243d5434834b47ce9d5cecbf4dbc"
    sha256 cellar: :any,                 arm64_linux:   "fc424af51ac49916f070cecec24a9388d0546dbb5624e6bb04651a6db1b00ea6"
    sha256 cellar: :any,                 x86_64_linux:  "3bb1bfc78efed9f18ee76f7add3e5d89d042d944aaa8844035e42b3da442e6fd"
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
