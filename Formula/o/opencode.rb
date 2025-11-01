class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.7.tgz"
  sha256 "7d036474ae87d4894fbf3a97c51da2219b191be7f026c5d70027d89d41435a16"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2b189ef024bf45f62becf708f9de01982fb688a012fa6ce0c958212446cb1d7e"
    sha256                               arm64_sequoia: "2b189ef024bf45f62becf708f9de01982fb688a012fa6ce0c958212446cb1d7e"
    sha256                               arm64_sonoma:  "2b189ef024bf45f62becf708f9de01982fb688a012fa6ce0c958212446cb1d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2693acaca6f39d2c05d81c8c3f8d1c5009ae3c257fb9a7232daee542691f0276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41fd95a82c306078dbf5c05be4fd73d3d0bd8bbf9d2372e9f1aa28e691484d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "068ed3f4de7f050686174d234089d11ae0c71a778cbacb8ef74163c8bdca0ef2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
