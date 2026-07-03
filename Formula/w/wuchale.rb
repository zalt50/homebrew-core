class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.5.tgz"
  sha256 "85ec1a9bc3027c2e8da308c88398c7edcd69b6d6c818336cace6cf9dc9855537"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6add0aa4613a5077750ef48b41f89a152934a1fa733db5d19b72e40ead07617e"
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
