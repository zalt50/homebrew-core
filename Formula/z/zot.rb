class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "ddaf0cada06906ea7ba18c1eeb460598fe1453b40c6401da864a22bd119fd7ea"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "227ea742c4b044db8b5672b2f9546aa7d4265d9f11e6362874874205d4469702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227ea742c4b044db8b5672b2f9546aa7d4265d9f11e6362874874205d4469702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227ea742c4b044db8b5672b2f9546aa7d4265d9f11e6362874874205d4469702"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea56108394343266b9a0bce4e7f0bb3535d29ce1e359d4dc7743c7cc5bc04572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a12914b97d83d808c77d3cbd08c98a20b665fe942d695c61b386a02ef4a8072"
    sha256 cellar: :any,                 x86_64_linux:  "bb575ad8ce3deeec54e878215c681a0f58821cb39db36ab6289e42b5a45fa8cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
