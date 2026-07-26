class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.278.tgz"
  sha256 "6ffbe25db3c3056868dcaec77088f5702c015ff838c9dec9ba26b00e0833f775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252fc7efb4489b4d1f9d3934a1aa547b22588786346e16e6a0de1c7f39e47f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252fc7efb4489b4d1f9d3934a1aa547b22588786346e16e6a0de1c7f39e47f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "252fc7efb4489b4d1f9d3934a1aa547b22588786346e16e6a0de1c7f39e47f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c80d0e03842496dfae45d985ce5e866dce6f70896de4821c059a6c3cd45aac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e936c6508f3bd191ac45e533df84c5fa3726df28819bc5b339ec5bc4d1fd810d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a82cd6272bd717fadaf9848eafe53e0b74586aa06443458d899a10f9f064940"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
