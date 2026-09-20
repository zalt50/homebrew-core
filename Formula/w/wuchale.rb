class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.26.7.tgz"
  sha256 "f3ee8f54491ebca2438f8f22e1db675890547dc38bbc5d985494e1662e1a2900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2c9b3eb10e63aa34355fed82ba82598ee07461d594c1ef6f1343d4d0ad5ded4"
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
