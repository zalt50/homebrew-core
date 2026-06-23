class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.8.tgz"
  sha256 "6b3bf5fdbfbee87a431dca49c0e89ace8874c88bcb1441966611459ef1e0c387"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2cdb1535d86ccb9e8ca27e2d6e16b7232d03e34057983dd69d4f44c0a9ce185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2cdb1535d86ccb9e8ca27e2d6e16b7232d03e34057983dd69d4f44c0a9ce185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2cdb1535d86ccb9e8ca27e2d6e16b7232d03e34057983dd69d4f44c0a9ce185"
    sha256 cellar: :any_skip_relocation, sonoma:        "752c16f9bca3ff81ebdaf185c93d5a59b71e825532c5635fb4f0c9b82d263aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6398d027eb95d0c854de42e7b494b3b0a5c828bf1df08393ac205315413da372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ccba3bbda3318b0875589f19e80b5cd2a2d26ca775ded27063b8af05ed5e8dc"
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
