class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.4.tgz"
  sha256 "f9ffca02a7d30e3ef6ace376c938ae59b3cac7ed2c2e0f22860e9ef0c7904b6c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de70859f05aa2af31592f2ba0946639956bbb66a12cb97650a23296f6696185a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117189c440fb4eb96daf7b303b59ecfbb3b457013b11297e1aac284ce01db169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117189c440fb4eb96daf7b303b59ecfbb3b457013b11297e1aac284ce01db169"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af744372f98a4f9f7636c6c0afd7c0726f082815dbb7ec6b9f36a648796374f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9505cbe6f3ac2580121dc3c968b10c75ffa33e5b8239cb059a59f82259664e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977196c28e00ec8f1657e1e051e312e6f8027b1ebf3d91420fc3c8daab98fb1d"
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
