class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a5092f06540749eb7e29025651e8f9c59819b6e8a574f7a13ebccb01243c2a32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1167339abf714b81a333fec80ab403206f5e62df43a30bdc1b545829d1579f46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7687f485af9040ff1c8ade4cccabf61c15ebb1bc1ddf2da6031e52c5e97cf18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b181a3cab8e3d28217f15485b562294707917122d43975da8fd13e63bd665a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c39007b2a917a73a9e5878f2c2a491f0795d47051fc922309f7f596aa058ad44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "89bfa687bda56506584298d3badbbee00010c6423dac56500de59cd039ad5524"
  end

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    # upstream issue: https://github.com/kristoff-it/superhtml/issues/108
    inreplace "build.zig", '"unknown"', "\"#{version}\"" # patch fallback version

    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superhtml version 2>&1")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML
    system bin/"superhtml", "fmt", "test.html"
  end
end
