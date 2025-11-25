class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "9c1c3d17d6313eac99c0402a01ac4cdd23f22a743d3c53cea8fbff682905a3cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e109b2556cdf3b4e65bf487222412ca2614006a756ce403cb4792f6fc425723c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b22458827dd858d9133da8a6a0ab87099614cbba7108c830832c2446351f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1eef244bb511cfe6ffbe274aa9546e6f8c7ba1f60882497b5296bed0e433e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2082880bcdbaf47e1cb861ccbfddccb9dd95b05ea3f562f0b710d3c7e9923b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f0b55c4fa4f5f7bf70802067a554fc1c5ce9db45198f611f8c4373f6d97c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58f3f894553c6a9dac5f743e32ce3f869e99c73455f9c69c7169e5c8abc767e7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
