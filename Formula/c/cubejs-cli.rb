class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.86.tgz"
  sha256 "6baf30a4fe14b6c7ad85937eb2a501b277295ac33cf1a4da81fe2b13697e7dca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a5187018e6f1b7fbb76becc761f98fdef45aa8cae2d7f310d05b57fe91d5121"
    sha256 cellar: :any,                 arm64_sequoia: "edc8f5c16b36c8c06b8d86b53f0f26e31df27354fbd0c910941a30f94f008c57"
    sha256 cellar: :any,                 arm64_sonoma:  "edc8f5c16b36c8c06b8d86b53f0f26e31df27354fbd0c910941a30f94f008c57"
    sha256 cellar: :any,                 sonoma:        "c9b29bbda7f33b179de4f7f1b8498b378aff9a714aaffe827359a9b2423dfaa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8f4e1c8da6733bb45e5756a1f61a78355659953e65975b85291e99f1646696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b42b70cee71eea6fe8241147381cab364d9ddbb4f8b1f58e8117941bb5597c"
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
