class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.162.tgz"
  sha256 "2c2986421a029747525ed9e6ac161b3c9156a9028fa094d84d36015bccb7e178"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "474b33394f0dc69a3ec96275115915f179b8f4415e68a94e18906811aa0a1ea5"
    sha256                               arm64_sequoia: "474b33394f0dc69a3ec96275115915f179b8f4415e68a94e18906811aa0a1ea5"
    sha256                               arm64_sonoma:  "474b33394f0dc69a3ec96275115915f179b8f4415e68a94e18906811aa0a1ea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e176eec21dbbf0ed86b9919ac66dbd6ae19bd138a09f36af74eee6b9c9aa761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cc5016fee19e873e71bea581717190e3ff090e9173a920835197373460f9670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80985f561bea52c30b406d1b688f4d8ae796e69140fa2eba81457d152419f403"
  end

  depends_on "node"
  depends_on "ripgrep"

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
