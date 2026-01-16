class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.29.tgz"
  sha256 "a78bd56d6b2b9e2581f571e6b3aa51eca7c3dd9c15b0bed34f7604de716fda25"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eb9bc710e6970fb1403b2908294f13c529a0543ea15be5a6edd963e29b9e69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c3952eefb5836e953fe2ef2b4eaa4f84cbda894f616d92b74a3d5532e59748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c3952eefb5836e953fe2ef2b4eaa4f84cbda894f616d92b74a3d5532e59748"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a7cc759037ad66e284c52be9d570e4c2fc7d625684b0dce31ccbab74f05fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17c42299d877c0ed739cce01b2e8bd1abd432695199bffeceb551e63c20dbd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8962767362e3cca83a7e49843a1873399599e140f8dcd678a7fc647d439c637e"
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
