class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.0.tgz"
  sha256 "9a21dc8980cf2bf42bc73b65888f3d2751dc0131aaa0f9de7b7f82745b4eab11"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "18cbfe23fe2a8ea61911256616e09cbb4b2b961f51d8e76071c74f5ab531d3e0"
    sha256                               arm64_sequoia: "f9675890db7d6e9d743d72c78b26857b36ddfa74dadc29e5a38b208725fab71b"
    sha256                               arm64_sonoma:  "fd5427219c03a5c9eb764f4ee3a88e723eeea08579fe289a6ec5c65a0bb65d35"
    sha256                               sonoma:        "d925e821dfbb00e7c8a96ac4b2a9c470086878ccd1df8881323c9d5eccaf7e9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b416763b0c199519c963179a52be45ef72a068ea0b4ddf9f49cd774d8dd950a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bc44c73117f9cd356d7d940313a883474382fdba6525d6722ac65f01752b43"
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
