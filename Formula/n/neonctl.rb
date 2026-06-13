class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.1.tgz"
  sha256 "157198fb28b7e324fde69c70768fc655999ada1b7c873554ba1725879fc40a2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377b196a668f107bee0f3011d00f676ae603e21fcf919103c165b61a1df957cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377b196a668f107bee0f3011d00f676ae603e21fcf919103c165b61a1df957cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377b196a668f107bee0f3011d00f676ae603e21fcf919103c165b61a1df957cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "05eb9df910eed9a4838f00c298d938a7a3a4c73b21869ccf10eb4cb683f85db7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fff5b39a1ce113508c1a07fed080257a83d1fbf42d038cfb3917562856e02f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211c0530cf243938b95431d06ca776ee957f0307ea6b0bd390bce7c61953f0ab"
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
