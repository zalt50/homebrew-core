class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.54.3.crate"
  sha256 "6fd5d0280bd311e6f3cde52c1c3e632cdd94d6f3ce3eea9c176310adf24b81cd"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc2babc1080cd3de30b67142d08accf160e11a8138133a04af12d57fa6646e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb80d7a8d61e6ffb72b41c4b4bb27bcdc958049318061ce024e34eb7770d245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fed56c0c71d1994cf8e172776da75d546fdcc8b95b11477838815e0346ff976"
    sha256 cellar: :any_skip_relocation, sonoma:        "175026942a64fe0526e854aea2d975910967224ea4b93f6d98dba448f05da69b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b5abc37212410c843001e35a884ec8ce4f15bea84070ee6b9d37f46ac4c622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44588c47bb7f7a04d07727c80cdf36b2ed7925eee38f2bb87128867e448972fa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
