class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f3a088d11e60439f3cc7970572cc50d4f61163439ea9205aaf16843ec8a7e69c"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c9d327ffd5ff0cbe55d99c02e6ed80ee78a40bed170d3400aaa7a6db0ff911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd10379a203847ae36a943942dc60434dc9e1432c4779278bf498d95b37512a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a47f0fb47cf09f4bdc5a32a16ede509e149e7c91ee847ca41aff81eeaa0462c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b375e7b719352098cf3fbf4ade9db79fa169b62aaa3b5b4acb4c84c2af1cccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5ab47f7cd1eea373986ead81f6992f0867f590fa4a8f71af448045d7189b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4589c81aafb334678e95adc205a80c52bb5f18646c174472b2be10e9441628"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    system "asciidoctor", "-b", "manpage", "docs/man/man1/*.1.adoc"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
