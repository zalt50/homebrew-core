class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.81.0.tar.gz"
  sha256 "4ae68e2b7d2b035fe864bd63ae71e35c600309331526b1993bd66a69dcaa76e0"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51d7ab9a910584b7b0d69d850ffb5d91b08f682390306b8c10067093046d0b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304d46fb69b336003eebcecb49f8063eb8006303d2cb098ec4daaf490a74ad46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b46d07ed16a393a93a47507f8be21705c83e3a178810b66ff86fbd4c62c3ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "e72c5c2398ac839e96a07e7ac3a3063fed3f9da902fe3e62e7bf6c64ee6a55cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051438433061c9706a5d949f33e70c4ba011ecf36613b2426ce013b8797b3f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647e92c06b8d8003e3cf55280d52d050b08b13907580603121d7bfe57f8bfff2"
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
