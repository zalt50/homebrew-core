class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.201.tgz"
  sha256 "19f712e2a5e0a4be65c380529f29e2402d1117ad0b270c53a03a51f69de10dd9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "09c75312a66c1cd069ac676a4a7b7e2459d704ebb5cecb409767bf4b207f4cd4"
    sha256                               arm64_sequoia: "09c75312a66c1cd069ac676a4a7b7e2459d704ebb5cecb409767bf4b207f4cd4"
    sha256                               arm64_sonoma:  "09c75312a66c1cd069ac676a4a7b7e2459d704ebb5cecb409767bf4b207f4cd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "37045bdd32a84be540a5415e52c7ab96752b9b295217fed59b3ecbd6bbcff684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "206c96e9df52bac7c347e06feda4aadce49ef44f1cd7fefc1af3b1c2ba06856d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc077a70e40dd80042eaca8503cc7a8e17b1b11e54ad7f476c40c334e477c00"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
