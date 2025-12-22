class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.186.tgz"
  sha256 "b28906685a17b9fe468de65178be5845a945a3e61048d336f42141813858579b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fe42257dc77748a20c63d0fa3651ab7f21e4bea56aa9c1233cf55490e8319408"
    sha256                               arm64_sequoia: "fe42257dc77748a20c63d0fa3651ab7f21e4bea56aa9c1233cf55490e8319408"
    sha256                               arm64_sonoma:  "fe42257dc77748a20c63d0fa3651ab7f21e4bea56aa9c1233cf55490e8319408"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e8d1d6f6ceb222b9d0de9d7c05c6118b8dde1ecf718233ba207e9f4696a4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd9da2459b54f6818eff62b98c35d305b65bfb756d4488fe4e2e715c15a3b2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bbd3ae3d0829901ad79415aed282a321e40998b6de3c3a7c2e63521bcd18f8"
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
