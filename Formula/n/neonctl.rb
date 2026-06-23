class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.8.tgz"
  sha256 "6b3bf5fdbfbee87a431dca49c0e89ace8874c88bcb1441966611459ef1e0c387"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e573cfe2e25526d41db02b3e0c604df28e4608c9534a959a76f30e13dcbc5c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e573cfe2e25526d41db02b3e0c604df28e4608c9534a959a76f30e13dcbc5c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e573cfe2e25526d41db02b3e0c604df28e4608c9534a959a76f30e13dcbc5c30"
    sha256 cellar: :any_skip_relocation, sonoma:        "981da245f035cbdfc3f6f1804690b93e2955cc14c1c5485782f622b261d42f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5767ca9c5258d04266653a3259fb5f1278e19446ae3125451a7ab26bc33484a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57da26fbaa4260bf90cc9ea0a5ef1f93a16ef9a2e478a84c31f4cf0baec12c40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/neonctl/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
