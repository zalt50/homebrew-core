class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "7ed8ad387a8b43d1f4a7f93ccbc0103f2c3e2f3d14b8af674ccda638578ce762"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32cef1ed067ae8b2fefc314b5a03db5a8820cdb6a00adb4baa9a62086764d1f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbc8677996a2d42ab2f0dddf206a8669300d692db9e028beceeafd11713967f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "021cb8dd3e71df7892ffed331cbb503e589866df468750e762c19d7b541fba95"
    sha256 cellar: :any_skip_relocation, sonoma:        "b00366f82d11c61b61178235f8c169b550c0beab0bf4eaf325e89f3047f54924"
    sha256 cellar: :any,                 arm64_linux:   "b8fa9bd17226de2c823826b0e0ecdf61fb0ff8cf97a08449fb4f88a3bac37a26"
    sha256 cellar: :any,                 x86_64_linux:  "c520483d6f0c330cca4f0d576ca48f62dad82abee9b2fb1ddd57ffdeb21a00fc"
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
