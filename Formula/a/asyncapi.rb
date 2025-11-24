class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-4.1.3.tgz"
  sha256 "76678b918e11bb9250e693243943067a2e85ae42a53add1dfc09c7723a2c3a29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b86665793599ac770687e80c078416589077512038e0aa5d23d66aa7836cbd6"
    sha256 cellar: :any,                 arm64_sequoia: "6c50bf9e49c38a38b224e21273b20c0775caf4c1356bf3c8d3bb6cf3b22f31f4"
    sha256 cellar: :any,                 arm64_sonoma:  "6c50bf9e49c38a38b224e21273b20c0775caf4c1356bf3c8d3bb6cf3b22f31f4"
    sha256 cellar: :any,                 sonoma:        "c76afb91e4ef94750d18849e840c55965c3c8b0e0d4fbde0de32584953bfc630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfe4eb7538c4522554568088771c1fd4cbf68b4f8f3101731996972ee5550f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7ee55be8ce0eec3d6e9c0bee4243ff42b5064441ac8c5f0e34bae669960a7e"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
