class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.23.crate"
  sha256 "7e8a60c0e17c733757750b2d38a9e4ad2396407f21b3dffc69b5189c5e9f29fe"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef263ddbd867c2f96f32d975a7ec4061b9dc0beec0ee320965492088db9e9cc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84496ea5ac1e32e8ba8aa40e2e68327d290b718bc951ef1cfc27ee6d7becae81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73c3c2c321fc916d47ee43f559d257d6e8be57dc93d0388c128aeeb50cb37403"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec6d7f61321dd074d39cf90de29df5014d2c990694f17471d4d0e8eadff92976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f607e977aee696475af51dc0c7f45aa8f2533c1423ec62290709655593c11a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094a53932ef90290e6f72264a3bcc263af236d7210db18f39b227607165c7d49"
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
