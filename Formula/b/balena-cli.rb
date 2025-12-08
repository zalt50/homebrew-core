class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.8.tgz"
  sha256 "7d0e6b7209cb0c88754df397c14fa9e7e742687fcb7ed406c6c7710a278a6862"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a87486f2f0391621a562490ef054ca3f851d1a6882c0968495e1934ec0e5b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e0efd1a9a2fbce2e604bacbc535fdcb0521b8dbcd7070a28f9f7f2f9d6abfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9e0efd1a9a2fbce2e604bacbc535fdcb0521b8dbcd7070a28f9f7f2f9d6abfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d277e08759565800059fa3a4f060a6dafea25bed510ee19baa07ca3314c21e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b29ea167cd3ed66189bc17578db2ce7e3c7cc7e4dd0765c2879caeebf29febd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2132bba5b99b1380e5917131bd8502dbd693a030e76f2f2399de7d4ada350b"
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
