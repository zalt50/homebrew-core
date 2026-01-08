class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "d384489b3b1eff7e40df5f0f95261bf8dddd0e7916d28954ff490783141fa287"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c60a47a42b009829c814017fa65c1e573499626ac6b98d7af1ad97644f2402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070520ed3fb031e13f9c1a836b32c89541e18c7c8178aea70f99e5c8eb3f7181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a93368251368737cb1180d07acfa7eb2ff185888a6c688f0affe7885d94bfce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
