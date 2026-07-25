class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.276.tgz"
  sha256 "000b8d03ea78fdf32def2d5ad088e9ec1efbf72a7cb9f7651d46fdcdffa8efdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df95973279f4105b31632a78a9984b483db107c3ce4c231220544375e2bcf2a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df95973279f4105b31632a78a9984b483db107c3ce4c231220544375e2bcf2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df95973279f4105b31632a78a9984b483db107c3ce4c231220544375e2bcf2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc47bcfe1faa2fcff17192f98902ed534bb43cb32f10cebaa68abe650e5455f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f8b014d53bbc7fd37bac4f500ee5a9ba65918da6129d1bf2897033ea09ba57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c28fd5f9f74b3ce7b89fcaf25bb0045cbdf6803ee4a853f574507a3f0548a01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
