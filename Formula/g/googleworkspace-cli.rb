class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "4bac177856b3a644938650624ad180bd8ae718ba9b6b1ce70745b4ba992b4028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8496699a870b49c3d06107dc72dfa919343955c5ea79d0c858f86d86e0efda9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72f2f307778b8eaf634e34cb79aa92cde51ae0867a9a4c4ed56230028971825"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end
