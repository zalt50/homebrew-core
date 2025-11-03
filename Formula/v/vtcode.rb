class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.39.12.crate"
  sha256 "17a32af149096dddeb8d261b64c45ed18ee70ba7c576aca89ed78eebdb708a8b"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de58b7ffe66dcb937a8a698aca5be522d0152939d57f9e64c5cafd4803878655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad765712ef24fb6cb10d0177ca114968371beb47e61453aa75d060e9873121fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e58535fcac9fc91534f9a4d9648c5f097377d4fd9458e5d74d0abb5235fc870"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce16b9f3b6911d0f3597e12082716c83238a5f0890f58ba0c49a88d3bc2920ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eaf261a79df8934ffe0d31a1e67ff63b64d68635d9d2183ec7e8a39d8e13867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85f2b0f3984e62128063034cf9c93503970604e297d7e49d39744defc42119c"
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
