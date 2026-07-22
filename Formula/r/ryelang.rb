class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.52.tar.gz"
  sha256 "925cba861430eaeb9ec8b523b5b7b16f143c8c20e0614ec56b913fb07aca567e"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8700267c2cbdd4c0381ee20cf8ddf2ce6f3f0dd7cdc0cb43424844182d64d31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb4a24e2031a92c627bac35494d60722f93db35c0c0299cbdfa8fcfe0ab1111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5bff2a3524d7ea1b2801d038ee08260ca442befebc8e7d901e38ee95586649"
    sha256 cellar: :any_skip_relocation, sonoma:        "08dc50876917461c9fdb914436f716caac49dcfcd16ebb1f1ec4b923be577654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0744232550c235b369e4a7affb721350d51d34415a77a10b124ab139c71af01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0952be91e9e4911226ced1ec20187a7db56eea5df070b5b4e84438ff0a1ebd4"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
