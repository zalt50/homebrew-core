class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.26.tgz"
  sha256 "7f575e31725caf3d6a49ed75a72ed87e51f664b7a1f6b91c2e8b4b9c6c668b3b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fbd1355f5761a067148dd8e96a53d03b9d60d00577bf296c9b1f61e80c0e8911"
    sha256                               arm64_sequoia: "fbd1355f5761a067148dd8e96a53d03b9d60d00577bf296c9b1f61e80c0e8911"
    sha256                               arm64_sonoma:  "fbd1355f5761a067148dd8e96a53d03b9d60d00577bf296c9b1f61e80c0e8911"
    sha256 cellar: :any_skip_relocation, sonoma:        "652e77844ce34ed0576164fbed73798e716f4dacdf62c0f9aeff57f5803789f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d101392763a12b38e825290eff436cab0d4ad626a7630852c93c769dc2ea8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e6f3404f16d624e7b1200b44e12edde80ccf3105e3cb5ece00aa9f1a80e227"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
