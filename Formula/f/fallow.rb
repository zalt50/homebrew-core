class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "7eb47f5af5fdc286518a1d974dccf810eface81facce21f12789fe1e6ed50f50"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2642aa579a94797f5cd422e1599de4aaf6f2a3310ccc6f2a7ba3e5d9839a1aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1835d0211c440d6b222b5e8b72186506401dbbf4201b1931f4585681584e3d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d139144a63cb98bb39e012b333365818a81677d1e2c3fa8956afa7894303b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f0aebe233dec730c6498217e0513d78df1133f05c418186d84e2baaffdcb7b"
    sha256 cellar: :any,                 arm64_linux:   "03c4595fd57a1354b046a970fc5700ec0076b356e663c340cd151aaa478b4608"
    sha256 cellar: :any,                 x86_64_linux:  "53245a9b5f7a55e89a51eca12c83f1230cb4f57dcecb3ff2726bb6bcfa98f9ee"
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
