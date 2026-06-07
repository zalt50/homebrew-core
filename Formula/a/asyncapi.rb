class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.0.1.tgz"
  sha256 "37af0e73566f2b2c0aed6a7831c980c00ac1156c413d49f7935a6568a5ab08a4"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a115bad3e03498e458e7d28b74dbc810ba8170a185a8c0b37de63c1bf0f1fdf3"
    sha256 cellar: :any, arm64_sequoia: "5e954a5f2631a5b73e7f17568ac7803ee9fb6df40ef755d2157b35d83c95ea27"
    sha256 cellar: :any, arm64_sonoma:  "5e954a5f2631a5b73e7f17568ac7803ee9fb6df40ef755d2157b35d83c95ea27"
    sha256 cellar: :any, sonoma:        "502f8f010aefa31dd53e0a21187b03a3ecb15db2357230e4727fa462d06c7943"
    sha256 cellar: :any, arm64_linux:   "5abc424bacc89217c4c1e6ec8556db7e4b373d7d6ecafd0fcf7569fcfb8df25d"
    sha256 cellar: :any, x86_64_linux:  "624fb2b7051106f37f4bb7ffd3d49e861e55ddaa3e8bb6c9a6e8161d1c8a9fcc"
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

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
