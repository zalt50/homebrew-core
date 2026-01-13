class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.19.tgz"
  sha256 "0095d64cb59e80ffc0b07315943c7c17aae89a799cc18f0a1822f8822f66326d"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3033e2b4365e2debff36880f5f29039d8390b64e2234a5e70bbc44e5c27f48cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f605f76b1a07b8f780b5d17a51f94a04f531b6fdb8453c216528998ba21cc7ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f605f76b1a07b8f780b5d17a51f94a04f531b6fdb8453c216528998ba21cc7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbdd2b0d6e5ff7853b0653f0d00a21fc347b84c64ae8fe18e4697c4596d5939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc28d3b3b764bdf0b5f518e13af2d5b69e4cf9c27b833ae0649affc9d0488089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686fe15d52c1708297033234a3bf8956ecaa85d0f4c01764fc994b2da36df332"
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
