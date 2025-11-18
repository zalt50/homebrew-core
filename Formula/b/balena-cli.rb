class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.1.tgz"
  sha256 "5d2bec2de3bd6666039d5d78dd442178d4a0225d24651a6842e9fa5e87f43ee8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "db65677b7cd842fbb65d2e3a60a5f140fabb01c5b6edce3f35c2e5b0a9ca2932"
    sha256                               arm64_sequoia: "72aade7e67370d8ce7ac8ae600871bc634e3b521fb2d27416cd9e97786267e70"
    sha256                               arm64_sonoma:  "96bceb32b410da8e2458df607333320724beb0eab3ad995182a06fefcf94e095"
    sha256                               sonoma:        "ca2fc1a6a514cc0bc11b314ad25ef9868b59a2505f1427c4f9e29c52dff7d82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "492089d5a8608ace669060ef99250bb7665cf6edac224a7e9343c44dfb6de73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ffe19f6b7544f111339f8255e1498caef6b40b353d65877ff25278a6c1dd422"
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
