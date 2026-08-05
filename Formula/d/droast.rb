class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.13.tar.gz"
  sha256 "9dd8e5913a7cff2822c1424207ff3ffb3761197795dd4ddd2cebaeb834311f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e308c4d23e7e1d46d63a7fa175595da583b0e38248172455a682f912e487959e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53cd443657f3bddf84e939bbb108b398f7336368af099641f8238c8ff20001d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d661b5d2d8df673d7e2b5de182c7e135f207cd9d78312847db007fbabf56eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "059b2e27cd5023aabd07b268dd511f7e12f79b7cdbae6d2ee70c61f17a14df60"
    sha256 cellar: :any,                 arm64_linux:   "21bb8c8e120c1a556e454e932469698e5679c023add3bed937c84278bf10db50"
    sha256 cellar: :any,                 x86_64_linux:  "3889ac87694ea9484141ee074dffca043c17273832dc7b522534d9375228922c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end
