class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.12.tgz"
  sha256 "f7827b4e3400d1a9063ee0d6baa3fe8efd277ee339c5426876653f3d1c471723"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aea8af0a5e1ec9b7dacb8b1bc3b54c007b71eb4b7f58c00f5fc05f7e191ff85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041c22d1ed363341ff0e04280788c8d2b196ca3f73b86c9290df29d0818b656a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041c22d1ed363341ff0e04280788c8d2b196ca3f73b86c9290df29d0818b656a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9fab94ad15b731f882d53eab610b18009418523cdef95e19f873a869939102e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3f4083cbd5dd435e35ebc55c0e3f690809349b4ea9153647c7c45e14838f34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce14c9a6a1f95131da52449e89cc2265f43b6b1d731c9c8f5bd0aa459fc4171f"
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
