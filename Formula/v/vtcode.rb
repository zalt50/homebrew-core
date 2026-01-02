class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.12.crate"
  sha256 "9c55eea568d869596ff12edf5c23b70596a521060e5ee83293a78e776272e06c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a28cd33cd51cffb076f69e9ac79a8ca7bddc2d9e99f5ee7fdc51c3529af4264b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946455ef80d78b0c4010939515d331b6e96f7aa3939fde9860a336e35a0f6dcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b201b88b10475fbf9cf439be54a514166808714d5bbbf938a0f384ff07d669"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aacc17b4a78f0db442f63acbf77240143fd5c035cde2d3c6c38b82ed003839d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "241349bc72b03e322202ff2ba4b955d822a0807faa8328eb21b4fa4b9116d007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fdc7008542898f08fa36ec1fa3e9c135615826b53b559dd471f2dca5e8bef41"
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
