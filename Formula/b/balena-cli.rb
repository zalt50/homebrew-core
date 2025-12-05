class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.5.tgz"
  sha256 "37ec1257d75424402a66cfcfcf37d1d81a567e99dd719e12dfb8a2100f748f2b"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9e0efe3398c10170cc5fe419c509b133d7ccc49957275cea5c05c3af5abbb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8837c107fde196a01c825b5e94320a368e56360f73bf24226908b84337f5b3c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8837c107fde196a01c825b5e94320a368e56360f73bf24226908b84337f5b3c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "47e2c35995a33f39ad41d559a95a1311341086509f424d143a8da8602cf0ba07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "568b1ad1d7e199e035085062427f16799528061ea7bbb58ca1428afb1ec09634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aba0812fa34d0a1d5d5a6d78159b43b2f4915eb5f994b59b81ab35433c58d7b"
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

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
