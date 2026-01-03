class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.19.1.tgz"
  sha256 "40d9531a474e3f67e726284278728b0aec3f2d44ebfc15eaeac995c08d291404"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75d74e4dfe658ea9d667d086338c0ad8f41afa3870eca437dd35b5579cac7de1"
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

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
