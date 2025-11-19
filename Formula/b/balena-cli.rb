class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.3.tgz"
  sha256 "b0bf59f0c4d2ccd7b3743683ab13a09cc60d81a42995a25a8662173424282447"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "8a2808b826013fead047a52e9ab94d47c46ce7306733c8e93d149476b9b0d362"
    sha256                               arm64_sequoia: "7eb4e72280c7eb1391c6c54ebc3b481cd33c111e08a4f87bf0a1cd881f1bdfb0"
    sha256                               arm64_sonoma:  "73364ea07572cf449361b655ddb110a5722679d19e3091bd397ca08e0e7a9e2c"
    sha256                               sonoma:        "024f1df856a79cedf7c062d7cbabc3c85bda14cf8e94d91763734fd0ee6a3fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e29d7f7e5edb1aecd50064732aa64b1f0164d90541eaab2c4ebff358e3fb0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e640b25f303c7b66ccaef2070532a8859a8630aa31f05efdaf30a6aad4d8f978"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

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

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
