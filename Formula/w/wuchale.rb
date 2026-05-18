class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.23.4.tgz"
  sha256 "f907f2ad1a72d80d848d5ac91534bf7d39dfff420f1f56a63d3340c33e1e6429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3d71be3af528097de09c4ea407f30b5ec207cb388f28c044ed76753929d1239"
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
