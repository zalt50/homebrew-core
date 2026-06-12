class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.94.0.tar.gz"
  sha256 "11d247f6e32c5d68149a2413cb530d3b8f7aa4d1af4f2ff495fa9ec53d542066"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "014a16560d8d2559f699822912f7c56233f6bed9642894b5b5680805ab3e0bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "183333466a33c3e3f6a6245877eb110db305243d4f41fad72090fb1bb17cfdb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3b28bf18b2d459287c78c98c8501f967e0df404fc5eaace6db48b436a1ea2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "168def7d6882ec38725de765bff9d78a1adc128c2c9d05edbb7684df3bb2dddf"
    sha256 cellar: :any,                 arm64_linux:   "526203ba3dc1c434268ad68da88f28ec44a8a09652cea7230f0c3ac779a7c0cd"
    sha256 cellar: :any,                 x86_64_linux:  "76c90dcf145f8c7a876b6bb50745c75c2472eeb4fe84eed786990672d9a70dd5"
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
