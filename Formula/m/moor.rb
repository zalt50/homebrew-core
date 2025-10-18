class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "e3f245d01edc1ec1de0c10083e2c818982e6d991a21063aed88064873f3123f0"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d37476a0b6b0cff1cff3ad26cc6edddd402e7606f12f0041d0cee4dd807b521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d37476a0b6b0cff1cff3ad26cc6edddd402e7606f12f0041d0cee4dd807b521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d37476a0b6b0cff1cff3ad26cc6edddd402e7606f12f0041d0cee4dd807b521"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cdecca86cd958d445ffa707b9af33d1b3802a7828b487cd6e8a42457428d21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44202aa681675085279d61a41d2707dd4e7b553eb8de8000ba665d595e1d9e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900c44b62c7f2b49590cded2068fe3f81c73312f639c79e3f8ec3215dc1356c0"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
