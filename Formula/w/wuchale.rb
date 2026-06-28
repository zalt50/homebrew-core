class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.2.tgz"
  sha256 "7e50f516274989ee28aafa42fd11b59c1cb7b3057d2856a10002014644388a5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99b4eb37246736120a89ade2a39dcc647f21359b060cb990f22d046da2455627"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
