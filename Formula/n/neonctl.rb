class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.5.tgz"
  sha256 "add3e59d9fc292dfa97bf2018953dafcca7ecdfb67958d274a9839cc3b108640"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90313d9e5e9bab8a8a71ddffe029ac2a53f5b6f11231ca2a1deaf1d25b607f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90313d9e5e9bab8a8a71ddffe029ac2a53f5b6f11231ca2a1deaf1d25b607f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90313d9e5e9bab8a8a71ddffe029ac2a53f5b6f11231ca2a1deaf1d25b607f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "7261834c667a87b29439d067486dbe58ce2037ce42b3a915f9bb45f3e938d553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6fc8411408e83acc57cbeff9fb099faa1b6571066ac936cdfc18787a83117a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3265a6114f8fb168b545bca2d43567ce04c37b2c33006590492f3e425e38cc0"
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
