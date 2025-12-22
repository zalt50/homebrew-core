class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.18.10.tgz"
  sha256 "3da1c4f69efc6ee87ee44bfb18dc38db19e120fb6d92ab63bc2f0a356b3a623f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4beff153c2b6e7d50b680bf1b54ece818e2de4a968634ea5a3881aec306d3ad7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {};
    EOS

    system bin/"wuchale", "--config", testpath/"wuchale.config.mjs", "init"
    assert_path_exists testpath/"wuchale.config.mjs"

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
