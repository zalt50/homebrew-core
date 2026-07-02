class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1129.0.tgz"
  sha256 "997ef66623ac2b23086e217d4c23cbcf957532058466cd004ae66691d91d5ef7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9aa11584e46e6dcebf808a621f3c8a89ebe28ee7ec5ced7c9c9b4f0ab6073e8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
