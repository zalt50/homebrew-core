class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.24.0.tgz"
  sha256 "a8c7fa27f7f580042be4395f42df058779c23783a25d0fe0bf3cec82fa44a181"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b17c5bfb4015be7c4ab4eb36eb39e3b6c95e98c1874e94f0c4ed6313c3d37b5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b17c5bfb4015be7c4ab4eb36eb39e3b6c95e98c1874e94f0c4ed6313c3d37b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b17c5bfb4015be7c4ab4eb36eb39e3b6c95e98c1874e94f0c4ed6313c3d37b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58d4648eb60c91920eb6d3ba53b971eb31e6cb36b89ca90a2ffb045f60df421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bf088dde811b27e6e12cb5d644fd01c4d0c472d8cdd180e44d3aa2456c4144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6a1329f4135c5db3292a36d71f55e36b6846118cafa858c8fd8694ef45b2e3"
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
