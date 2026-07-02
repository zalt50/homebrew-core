class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.29.2.tgz"
  sha256 "2c368d4fa69d5ced561243eeb5f67947dfb46310aad23c806316eea59e5c6cd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb847ec6c2a1834158324f62f4297e39aabe1c258c1fc35dc7d10c63964f67f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb847ec6c2a1834158324f62f4297e39aabe1c258c1fc35dc7d10c63964f67f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb847ec6c2a1834158324f62f4297e39aabe1c258c1fc35dc7d10c63964f67f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe4f5fca65c7cf02260bd86659b5f38b14bd22465f566d1241befecdc5b20ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f51803c4862fa75045782d5e8742d8d3a98981755d6e2dcf923797e166f14bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfa124bb6e87ca2ed2757579494e8941fa4060598a867ae44ebcf6c2add63b8"
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
