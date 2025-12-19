class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.170.tgz"
  sha256 "14b31837a4736368396d1b350bc15868b9767f49ed531ac564deaa7162a47acc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "14fd543840298148d3e6fe761def39d8d9091b79de6b2d016e8ba8539166a139"
    sha256                               arm64_sequoia: "14fd543840298148d3e6fe761def39d8d9091b79de6b2d016e8ba8539166a139"
    sha256                               arm64_sonoma:  "14fd543840298148d3e6fe761def39d8d9091b79de6b2d016e8ba8539166a139"
    sha256 cellar: :any_skip_relocation, sonoma:        "b898dfa14022b591c15654bb2b13f591b4c8559c7224ef0f46eb5d6f62444978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f359a00b58825627bbb561d6e7636f4623a641535d4e18434174eea1c65f3cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798cb8febc85a8229ad7767378187b200f2453f9a962a28809711eb22dc31eb2"
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
