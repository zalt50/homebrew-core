class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.0.2.tgz"
  sha256 "7b300ea390eebb5933e2b847baf83654f8ffa8cfa1c8edc16b5be15316537b20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4798bfec559745464168aba0d6047b1db1337495d27edb12a2acebebe3fc644d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8c4a1bf31e09cb091860094bd11a00f69b1f0c2f5d2da672a2c48bc0b81edf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    prebuilds = libexec/"lib/node_modules/tweakcc/node_modules/node-lief/prebuilds"
    prebuilds.children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "#{os}-#{arch}"
    end
    rm prebuilds/"#{os}-#{arch}/node-lief.musl.node" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
