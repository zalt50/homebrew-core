class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.29.0.tgz"
  sha256 "08e58a32646abbac3b915ce7a009e21b2b1b8d28e13ce847c8360636636f3331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c47f131cd2dbcf08976c4880add3ff32bd864b2e101a08eae4e4ebf9b0c377c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c47f131cd2dbcf08976c4880add3ff32bd864b2e101a08eae4e4ebf9b0c377c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c47f131cd2dbcf08976c4880add3ff32bd864b2e101a08eae4e4ebf9b0c377c"
    sha256 cellar: :any_skip_relocation, sonoma:        "236fba70dc843586e22ba9f31e13466fc24c31f399e45ce0507a016b34ff7a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd655c568210cbec7dd0871d767ed6ee3f912753ff31869ccb9ee69f80897f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c71f950afed3b6255a0eb41558ee868ed82305e43b20ce27d179cd0e181af3"
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
