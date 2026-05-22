class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.78.0.tar.gz"
  sha256 "a25b5077ba3f693b760083eb48eb26feeea5239847910b6b006cf093ad5be264"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ec280284fd014959d0e0a43b14a6879ddaf7170bae7ee08ceb94abe5c384440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0cb953cbc3c8a61187e5a4e6ae097fd2db6144bfdd629324d74a1e533dc9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1ecdf1fcf0640132cc225757aa2c8c2191b4c9a35cda1dba22f07c8999921d"
    sha256 cellar: :any_skip_relocation, sonoma:        "30bee513f626a6ead190fb5f6b987597b2aee8f7114069c79a76fcd18c4895f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fda828b29ab8709dfc2af71a52cc52124d44048c72490a637923500a923cbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7711976f51719f19596a476c79828c351842b6c85da7fe265092951084d4d7"
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
