class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.88.1.tar.gz"
  sha256 "e4d6171bc685c8498700bf212fb2f8273ed229769cb70e02df12ce1e2a3fdada"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7de80580d396f58c7ffa213922070b1c09b845030e528378122d5c9e7198cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0e1a90482f3fa877dc1cc9b823f39a262b0e19b99c87130419917587281985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f44c812886cf6b052cf564ffdf8cc330bd2192b065283508009fc28ce22a6df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e0bc32df29563a333c8f012edf11078815b650ace1f10cfc328b02960e03040"
    sha256 cellar: :any,                 arm64_linux:   "c9c31d46ba088f87cc3e516c473b07fb2b05ab517ad22fa61bce8e6c1213776b"
    sha256 cellar: :any,                 x86_64_linux:  "d246de876e6754ec430d648b0e59cc93c4e1645cd9ba3db562af2c071a506fda"
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
