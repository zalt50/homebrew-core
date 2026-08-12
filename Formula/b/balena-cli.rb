class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.2.tgz"
  sha256 "1dc4b6460e29447eebbfee58c1f135d5b9981eb6eb903f47443991bed8eb7436"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6417ee43e5f0015b1f95265add02ab314e2bda011b6691ade352f4709e46b482"
    sha256 cellar: :any, arm64_sequoia: "6417ee43e5f0015b1f95265add02ab314e2bda011b6691ade352f4709e46b482"
    sha256 cellar: :any, arm64_sonoma:  "6417ee43e5f0015b1f95265add02ab314e2bda011b6691ade352f4709e46b482"
    sha256 cellar: :any, sonoma:        "b4fdfe43dbdedec6fedc9fd00973ee69369be999da196677ccc2e39be6092551"
    sha256 cellar: :any, arm64_linux:   "1bb21bae8f5ae06dad9299dd612badb61ca31db52eb67d8eec3b9170a343e8a3"
    sha256 cellar: :any, x86_64_linux:  "5db408ed52d73451db964f34b156419a3d01e3b2ff1488d8ca2f39bf0343e90f"
  end

  depends_on "go" => :build
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

    # Build dependency @balena/compose-parser from vendored Go source
    compose_parser = libexec/"lib/node_modules/balena-cli/node_modules/@balena/compose-parser"
    cd compose_parser do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-C", "lib", *std_go_args(output: "../bin/balena-compose-parser")
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    modules = %w[
      bare-fs
      bare-os
      bare-path
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
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
