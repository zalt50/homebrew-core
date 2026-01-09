class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.15.tgz"
  sha256 "e71fe6e0e59be52ccd11702a44e56a948779591fc94bcc1f95eada9d06ca5ee9"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93efe7e0f9f5566e9a7fcaa5017e852003d8b1fffd23c391713c4f8f9aa8badc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1629b1f60ad22b6bbeaf1c50bd0f47cf528dfca6849e27c4f9765f02b7ad401e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1629b1f60ad22b6bbeaf1c50bd0f47cf528dfca6849e27c4f9765f02b7ad401e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d6c94fc4055c03ab9929cf82eb53950633ae8f227f5761d84d56f444045e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef749dbc62ad821837c44ad5dfc0836d32790221ed3d57b91dfbe9dadba8795f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "916593d3c5c05acc9d4e04e8b5fb9cbdac828619d4e32e947e26be3c2b432ec3"
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
