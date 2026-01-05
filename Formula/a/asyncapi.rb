class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-5.0.2.tgz"
  sha256 "645583d768e8346d9c8362f554597b41683fce088e60a9a12f74e121516e8fa0"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0dcc2554b21e9dddfb764130b01aa4ad024d643005ecdc15ea82de387c5aeb56"
    sha256 cellar: :any,                 arm64_sequoia: "caeb7cef5131648649bf693c1d24fb8b33bce5ac965fcafac2c813b709204df7"
    sha256 cellar: :any,                 arm64_sonoma:  "caeb7cef5131648649bf693c1d24fb8b33bce5ac965fcafac2c813b709204df7"
    sha256 cellar: :any,                 sonoma:        "a29419f5f3d05650a2c92184f7f8faa9d2f10236564b7845f4f8cf990bf8a7ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513eec7245f755532017a9f2e2444ac758857b78f560d191a1e35e6a93651e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf333b9c43b80b54cf41d41b7642031ce4021fdace6d24338485a9c39912264b"
  end

  depends_on "node"

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
