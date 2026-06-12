class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.0.tgz"
  sha256 "52eaecfea6648fbf3ecd01dbb6b31018fe317db758a3c745528d54e17ad52065"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
