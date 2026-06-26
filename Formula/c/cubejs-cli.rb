class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.63.tgz"
  sha256 "2da39ac78ec978faae219cc45d938f1428bde4bc2a61676b0fbfbcb72331e6cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f40d0411895b8d7caeb8e966b37539bbc3b8eda5cc17f5aff1f6fedfd14841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a52076baf3f5fd54029648fd33304c861c0c540d06604243cafd8f8c8578b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a52076baf3f5fd54029648fd33304c861c0c540d06604243cafd8f8c8578b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c7d8df82d8a299ed8457e4a495acf298cc2f28b701248d93627a622e312084e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b11d234fd85b1fbaca56b8e155b0b4e1e9d53dc94e14f3eec27f681e727afdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11d234fd85b1fbaca56b8e155b0b4e1e9d53dc94e14f3eec27f681e727afdfa"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
