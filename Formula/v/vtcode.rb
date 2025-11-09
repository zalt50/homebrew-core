class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.3.crate"
  sha256 "618e88c3910ff4a566dc56d2e7f3a9f99e966a375d7ab3d58b37b0af0b35daec"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f35a97636e659ff1d5acceb5e22903c42f212b882ab98ab5b13713cf97cda1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdba2edd62deb4ea959f1f466fbf2e883f275ee30641dfe3c85b814af16bbff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cda5bfbad9c0a027bfc2e94ff87c86e91b25423d5ae6d368fabd4d02bdcc90a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17374d346868057f246658db91f856d544154eab35b0ddc7254847a9f283c1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3921bc7fed5bc25441ad94edd28c1ff1a1c5d090f38b9aab14a8e113e6a7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686c674abd1acee32ddcb0c09445767667daaab1c01de342a31b39c9709f71fc"
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
