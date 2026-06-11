class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.24.1.tgz"
  sha256 "43ce8ebba27c96cb68137c7891c68db8375c7b8d07c4b87792880e320aa63da9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5600dfa2354998b69fc1745121ecb7b7681d0ae101b9a6a9de1c1c29c1cd891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5600dfa2354998b69fc1745121ecb7b7681d0ae101b9a6a9de1c1c29c1cd891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5600dfa2354998b69fc1745121ecb7b7681d0ae101b9a6a9de1c1c29c1cd891"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf1d119ca25d0b4d4a522e4e86954afddb67d24415068d6a3a1fba90d8d29dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9eec0e47b149c6ff9edf668241e2928cfb05c152d69fc7761963fd8fe4a732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de3e3cf994b0a9630957de58351a3177c332971d7ce91e5bd4a701b73197628"
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
