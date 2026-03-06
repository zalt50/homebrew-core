class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "e1b5a11d9f334922c4325bf8d93f1e9f3abdda7135867f2931162617cdb3b4bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9086e85e4d6a1c3376342abbe74fd9dae83d57b945b942470c8c0c151b3acac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8112b6e1fd0b4c23b894ded4b8d976a7a807637559cc351982310c94e34c9d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20343f99022c3fae1f21c1ed245d0fea9d2f5f43f01f33eaff4ea459a0a5e8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a516021826530b281a9d9500bc570fa58fda5bf88fc9200b560360d9a78685de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca1374d20d2d89f553372abd94bd6c1e25bc98ff07a3ae27d9da178c9d581f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d1a14525618426bb725ec2189e9f5655bb26ffd75d6d75f4ebe1681dd9d73f"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end
