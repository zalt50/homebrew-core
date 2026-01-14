class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.22.tgz"
  sha256 "57f02dba314a5d23b29c274b42112a7b327181c86cddff014ab7188aa51cd437"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31db2258342bd56b76b6f09007e6f3b3cfbd321d9a86459bc2fcfb6f0b8ed13f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ba3dbfe3f3e23f323a4f58355893080306ece1dc7002f3ee4234f0ae9e4832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ba3dbfe3f3e23f323a4f58355893080306ece1dc7002f3ee4234f0ae9e4832"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbdbd2b80ef20cdac9f0cc1be7ea5c2af8f8dabc103f070b06986d4853651399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174747dde5676744a0fa13cf7fe36f3cacfe9a694074e7a6a07e31af941c330a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0dd11a5cf75aded03dab4ebe2f9a49cccddd9f929b5c07d4f855c70d029c8d"
  end

  depends_on "node"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
