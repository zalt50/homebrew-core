class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.13.19.tar.gz"
  sha256 "0d3a1b900633c15e6268b4794e42214b5d486fd7c0bb2ee398c8e2b98ab389e9"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac2fb3c996e48fc566eafb3098bdc4f69314dbfb9472b8640a326c0cd246c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f3e172415c655e2a28df13792cf81f4cf70958f86c9447410a006017937d6c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fcf6b6a08b4fa9af73bd931779fca76d627156e4754c21137db8bb1d15a085"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b719ed51fb0f422b4b904fd9716c0ef3e7ae287405f0a0eba3f3d9e98517fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0d60dda2506dc7649b2a45af0a57264fd5adb03e5fcf42b95285e16b5af463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe607bd48a10a001d35d12f58383ee2f5379669738808e211dca5e21a5f7c3c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
