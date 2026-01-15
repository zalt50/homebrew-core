class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.24.tgz"
  sha256 "2b2a6f4cb3e9984a1a9509789109cfb0e65b4a24b42ecf13a9c85fd402b0d9c9"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9f2720228bbcc66ceacec0d81b24c5a0fc0012f4d17953639bd8401889e93e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be55bd07dc09e795ed24675e5af03e9d3cc7eda58915d75c01822bf2b2a1d8b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9f364a5a05d8309e58524237b4829274307e624b084498dc7be1f1f2b7e921"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a5a1e474ee3005c070b656d25d8f19bfd733b96afe19316e8b5a025af103296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704edffeaf83543d4a619dd8e9e59898dbdbbe28b432cda38050d57bd226ad07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b7d69e407f416abc09ea8bb4571ff3eb589479f4aa3e4c65600fac92a49ab1"
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
