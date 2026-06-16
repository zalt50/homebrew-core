class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.4.tgz"
  sha256 "4251e4fc122cea2552764e6032f024dc884545fd99831bccae71059e6f5d4028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee7bac4a632ba07a29c2ff7583b9215589b37d0d5577f0a0bf2d9e26f9fbdb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7bac4a632ba07a29c2ff7583b9215589b37d0d5577f0a0bf2d9e26f9fbdb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee7bac4a632ba07a29c2ff7583b9215589b37d0d5577f0a0bf2d9e26f9fbdb52"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e2256e17066e78b6750296e2a4f6efb87c0209bf6cab20e0a5f34759ef0ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3b295e741f0e2ef25f63affefc7710ca3b0cb9eca51412879ee855bb118f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b55a42b0a62cbae39904a7415ea347a55fa15adc9db180faf1193953ce84d7d"
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
