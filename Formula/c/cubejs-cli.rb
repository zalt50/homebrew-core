class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.0.tgz"
  sha256 "edb24db1254fb6823e9d498976035e98eeab86126d6dfa2c8facd823cee51474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "155cc7ee3c6c9f2d34fb0477b904078bb290f038ccba8a2c96e9b8760adb4480"
    sha256 cellar: :any,                 arm64_sequoia: "678246e9c5e745610449aa40b7c64ec8dc0d30bff3fe08d6431ca5e5b05d9534"
    sha256 cellar: :any,                 arm64_sonoma:  "678246e9c5e745610449aa40b7c64ec8dc0d30bff3fe08d6431ca5e5b05d9534"
    sha256 cellar: :any,                 sonoma:        "706df46fcb47723a2a2e269207afdcc484c22901cc15ed2ac08537d1a68721cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ad4b68da8273bd9cc4c9df804373105ef01ff2cce59a1ba861d5b4db7d9732b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5364d1715f72def0aea4a38f17e96120d875179bbb9d04f6838f0c7c20ed1a4c"
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
