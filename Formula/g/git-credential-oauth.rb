class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "61a79ffcb51c2e3a37ec56c99c4d9a738322e0f47fdd6ffaf456a38589f27877"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02b14379bee3ddc468c48c7f4d717e4ee237ca45f7d8f1d17b86a7f4668e4d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02b14379bee3ddc468c48c7f4d717e4ee237ca45f7d8f1d17b86a7f4668e4d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02b14379bee3ddc468c48c7f4d717e4ee237ca45f7d8f1d17b86a7f4668e4d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "55927576479f611a8c1ecd25b5699a08e1e97dfa1ed94bc0b4aea5ca67b1f07d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eed2466bb45f47fa4edd5e68066aee391797af2d28d6a57abd3c745ea7f59504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b42a9b91efc3a3117eb4f0fb05c0c0b890f394119fe6560930225ae13b7073c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
