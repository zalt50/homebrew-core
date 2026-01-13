class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.18.tgz"
  sha256 "df38f30803d3ecf7162fc3ce0ab8948e878eb053c160e286c06c3e00f2e34eb6"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "714dc5b9364c500da4220868a57709146f2dc9dd86f05feb3ea09074d6201f0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62243c7ce961a60fdbb1d0de1bc49d5ff68479f1e913961eb39df6f8e1cb23ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62243c7ce961a60fdbb1d0de1bc49d5ff68479f1e913961eb39df6f8e1cb23ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc1f89b7171ecd306a101c824ab2f0592a1971361b0b832d0ea42a059246153e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b265ad09b33137481861d3911666177d80e6e866563c11359d7e7d5fbc9dea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a049250142f159fe7b0f0fc3ac7e3daef96ea61863826c8368fd1fdd2f2c0cf"
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
