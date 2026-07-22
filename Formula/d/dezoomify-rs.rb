class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://dezoomify-rs.ophir.dev"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "af3cde2aa9ae5c806c66afd85d077a7b7a4dbca862f18ac3a2c799add874c82e"
  license "GPL-3.0-only"
  head "https://github.com/lovasoa/dezoomify-rs.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd825ea26fbfae1e5ebc7507bc43297124c9e88f1a1766e1ae07e15ab624e9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db37997d0c97362141ac804b8661134c365ef45859de7e520636f7bc68eac66d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98a4b9e57fd2155b389f9aa95aa055d2608a137f7987614cbab5fdf39bd33800"
    sha256 cellar: :any_skip_relocation, sonoma:        "5998b9241ae4e786762689ec60637e9b56a0b09614d4d68818510edb08c99ceb"
    sha256 cellar: :any,                 arm64_linux:   "d7e3866c2d00893a5b4ebb541dd1d5f61fe5e42808029a59133dd93e4f93417c"
    sha256 cellar: :any,                 x86_64_linux:  "9146a2aa7f9dec5335d9c516ec2196f9b116fbcc6932175e69625a534d00c357"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiles.yaml").write <<~YAML
      url_template: "https://cdn.jsdelivr.net/gh/lovasoa/dezoomify-rs@v2.11.2/testdata/generic/map_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    YAML
    (testpath/"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml testtile.png 2>&1")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
