class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "26615db3644bea9e1f610a7d53dc83f366a64e46dbfd2efbe45284f1cb7b9e3b"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4189c9a089c7dff88db33d591ae6248cc448b394b5f61b667cd27d25e901ee7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, sonoma:        "89981ade5d232179f4f30d9842286cbcec53b012db792edce069837d8496eaf0"
    sha256 cellar: :any_skip_relocation, ventura:       "89981ade5d232179f4f30d9842286cbcec53b012db792edce069837d8496eaf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b664ffeb276c2f87bcc51836aa3f5eb962e25d9fa6047865843ef74dd6759d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0722e0df4cd81b34ebe80025de7393276c27ad51961f0691c31838ae810651e4"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/okta/okta-aws-cli/pull/292
  patch do
    url "https://github.com/okta/okta-aws-cli/commit/3d3d19ba7ea0925f61c3a090cf24d3647622b285.patch?full_index=1"
    sha256 "dfc56e683281c3c0b8ed310eb66ebcb75b9cc08479301b02a6da33d3b1d12f8f"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
