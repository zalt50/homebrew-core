class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.85.tgz"
  sha256 "65765a2d24a43f0a295ae37bf2ec76391aa8a53f9ec42653e38f1854197df23b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28a6b3d7f4692f9e0e8388b5977c998612956ed702c19569cbbc156a8be441f7"
    sha256 cellar: :any,                 arm64_sequoia: "73d6adcb1a00a1e0b08c1efeb13fdd445f104c8cf899259198302fff7c84bda4"
    sha256 cellar: :any,                 arm64_sonoma:  "73d6adcb1a00a1e0b08c1efeb13fdd445f104c8cf899259198302fff7c84bda4"
    sha256 cellar: :any,                 sonoma:        "3a697439e4664429404fc0ec1f530ac005ff21c5a5c5e400b3518151d6e404d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f10a830d588a63848a2020832ef806130e15d22ad7d7ac7581876221e21a1832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec3aa5936e00ee1031c1f989a98e8dfe74d00634a12722bff1f6928bb3f3974"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
