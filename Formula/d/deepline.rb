class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.278.tgz"
  sha256 "6ffbe25db3c3056868dcaec77088f5702c015ff838c9dec9ba26b00e0833f775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01f6d01c5f1581063a8bd63cafd39e5158aaa5b71e3fd81ee816d18cb40a7503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f6d01c5f1581063a8bd63cafd39e5158aaa5b71e3fd81ee816d18cb40a7503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f6d01c5f1581063a8bd63cafd39e5158aaa5b71e3fd81ee816d18cb40a7503"
    sha256 cellar: :any_skip_relocation, sonoma:        "511cacc48cba82b510e13f8790dbd17cd4bbe25909a436f47014553664d84f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1fb2d131206212c51055e0d52d8b33d95fd84db0dc4afff120093f1266a61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63262776c54c3f7929960b949d690bf4c694f18697f9ae2c50be0d837323cb11"
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
