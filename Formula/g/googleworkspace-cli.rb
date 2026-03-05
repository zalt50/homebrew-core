class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0013c992d7381ce8d5e5d09c79a132a2c5e548e9e310797ab84e301488856192"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17f6c277e7c3c57a968b2776a2306574afc32dfe6fd64b977643062465cdff49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298684bd45dddc9a47347c97df5b294eab00a38596a9c30ba197005c3d631b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa88cf852b9d3114651c0b498dbe570dec8fe66a738ae668a9fbefbfd3caa5a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6febb796001130e09333f98a565c08501c8fe1f3a7c39c714e5927ec5e98dee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37ccd87879e8be060c777b665c9f79e1004d983f64549b6f3b75fbb6e6a6752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a0744ea692e08e14048611c514d77c20d580d2fd4ef8531d965d277d29426e"
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
