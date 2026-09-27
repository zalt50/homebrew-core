class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.46.tgz"
  sha256 "956ea7477be76e97bd765b84fc1b2641f7d7eb2c2da794decc12d5b3ad14df67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3155432e681bffc46a1ad4f185d378e825023ebcfaeacbc123a36a32c1199206"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3155432e681bffc46a1ad4f185d378e825023ebcfaeacbc123a36a32c1199206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3155432e681bffc46a1ad4f185d378e825023ebcfaeacbc123a36a32c1199206"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f9c9020dece85a47defa60f92b1198d7a4e056c130f766ed1fe1c6ab2c002a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8f9c9020dece85a47defa60f92b1198d7a4e056c130f766ed1fe1c6ab2c002a0"
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
