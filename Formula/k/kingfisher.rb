class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.63.1.tar.gz"
  sha256 "93b8fbe1c86a0d811b803f004f25b4bef22c3ec03b15155a461c4e8b1848cce8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99bc62466c3f7e0ec45835583b55beac01039bab318f19d3d340eb9a2aca2e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84159ce4040af492c5a909e338ba49672e7faada27cab7eceda78d3869a6f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e33ff15dde228d2ea6082184c59906626c552a8475f0bf195a19a6dbf67130"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2983b11eceb8c5e5cdf113c4d1fc196252702c50b4c77cdcf1e6ba970bb14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1027c5f346165e304b10ce1e05bc6e062bae5ee38020d424f03a80b897f5a27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80e7ed247a32f8d9ac92d51ac33ae052d400a29b368e6f0f711c7cde401f86a"
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
