class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.14.tgz"
  sha256 "ec1bb9add09ff5a65b8d01fe9589b9cc1b874b1f5e30f3ad302f6b2eb9b0b303"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bccf01018c8d7273de9ac680cf2f2567b46285f648e29c5c362754f1a61bfda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5338c74da18cbf58c636b18d974b21e7435c95b85f3369210fbcdf0732c4f708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5338c74da18cbf58c636b18d974b21e7435c95b85f3369210fbcdf0732c4f708"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddda04425300547437c43a1de5458bb73a9793740de5a61c59e7746d748b76d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc2f5f17441bb9d520ca28992224f749dfbf5d9066c44c7e6a0dd131a37eee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc2f5f17441bb9d520ca28992224f749dfbf5d9066c44c7e6a0dd131a37eee6"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
