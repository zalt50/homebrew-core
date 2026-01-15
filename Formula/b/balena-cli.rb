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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e8cbaa7f0d1f9211b0be5afbf973b5d590762e9e9715c3ab565aec87a34bbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0152533dce6727f90822a47f74240b6c64e67985c623fecc66e74681a5df5ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0152533dce6727f90822a47f74240b6c64e67985c623fecc66e74681a5df5ba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "098980dcd466976179f3f3d19c04f3bdc29303130c54a320c133657ff94854f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c263e73885e2feb0f4549177bbb4aafddf87491f656dfd4ebd7e163e776586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522bf2b8891097b5f2f96e598feb1382883eef0ccc71454bb0b14938fd75e766"
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
