class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.51.1.crate"
  sha256 "58b132337dc06dbd91279a881e255925f06dd2bc7ba443c86134c2e43188f652"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3688b21cee56fd3bbfe54dc8f0c6542e81b4f85ea6d33872ecca1b2fe402a2c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e37c1ef8fb59b784573ec82047910f6d797284271f2bf0e7a1c7bb398c11dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0469c5fe75006dd97530c0e4f6e17592f9f7265e5f7b4ddc732de7f719b6381"
    sha256 cellar: :any_skip_relocation, sonoma:        "c16de6e67f64cd60552aed2e2e5b95c456279a166f725174083eba97d3dc7e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85fb8c7d703042127ffb276a052744bdec153238fce32618f5273ac08fae1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a839deb8b73098738ded5a575a5834e3e5f6b6e2a037f08603580f0f9443b9"
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
