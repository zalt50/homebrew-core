class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.9.tgz"
  sha256 "21b2bd4874929feea23d437a0348c07a34ab2d2123fe9f4645a7597e4149e2b2"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f8ad65104368c7debbe7a37e5b6f7748a7984f6399d069db3377f1fce76529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b56004a6e600ebd23fdf7f8fe90b420dbf72c3fe1e4c4d375b6c8648bd7771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b56004a6e600ebd23fdf7f8fe90b420dbf72c3fe1e4c4d375b6c8648bd7771"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f319172aa7b5f21d6d4c1eb9b8a19cd1cce50fb1a8c749aaf44b1b124c723e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7319d422e56b0c58cfac9654175d15a5641c3e29ac84a6b4bd9b2a9addc75df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c08ea4a7a0b91577e3a95d7863b893a452b9327560db812733bbc954b2a6ae1"
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
