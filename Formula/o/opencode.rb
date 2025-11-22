class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.99.tgz"
  sha256 "dc3b8b0e4419dd9e42053504be3d4b7e1ec04773b9c824165346b424df0ec575"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4699e7e848daccafb33a049e382ec7d30a9f90606230b8c635bcd43ccfe39003"
    sha256                               arm64_sequoia: "4699e7e848daccafb33a049e382ec7d30a9f90606230b8c635bcd43ccfe39003"
    sha256                               arm64_sonoma:  "4699e7e848daccafb33a049e382ec7d30a9f90606230b8c635bcd43ccfe39003"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e073e18a0d59b776e5a0a680b46087f45f1c257653801286fa1e7da133641c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3af52f6aab0bc1ddf8c083a16c406577e8ba106c7ddd3f1870c31f6e2ba565a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647914184ae12a5925b82136b4705f79763498990ea7363f070f2ee648570994"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
