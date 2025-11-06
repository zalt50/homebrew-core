class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.34.tgz"
  sha256 "00ee2d42c9fc4956c4bd4f776e0d608e516586f05b0bd03d0fbea6d7a6a4abc1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "84010b563299e70dc1244ed442315a2e6a97cb437aa02f12bc2a18e686cdcd00"
    sha256                               arm64_sequoia: "84010b563299e70dc1244ed442315a2e6a97cb437aa02f12bc2a18e686cdcd00"
    sha256                               arm64_sonoma:  "84010b563299e70dc1244ed442315a2e6a97cb437aa02f12bc2a18e686cdcd00"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb46513a1b3bbe3d989f7d6ac030d437c6b7a74b49d6dbf5f66b1103fe41012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83060ba8e9b5fe8180ff7c3c70b8753cad57e1ff7273a958a2b990acffcb084e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71f22809558bac7a529982631bc6d5d3e7bcd4f3518f69b2e6d92794e59d9f4"
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
