class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.59.0.crate"
  sha256 "cbfcbf4e23943074d270667b94b83f45bef80eaf48628d2d1d97fa66ce0f180e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "593578206d440398bec774342b3c01003f7e907a153e8bbfe4d71393efc781dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2bc5f123190664c6e1465a10a9838659095cedf76a85eb74b8f7903ed4eb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d69331b3f0f21c2dd6eb46436568ba1f1e646e73c36330ab7b4dd31c846c5a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9955ef63120474cff5bafbe2f928e9d4dbdb3d153e5c1a8dc99977d82f4e34fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cb979a5290dd955b90b625652e5344daede3bd972d25b7be1ba1e2408739967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56b220fdcfa113534b6b210f8dcab6973d1c5af437044ed59ef86e043444fd1"
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
