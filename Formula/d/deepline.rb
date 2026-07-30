class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.320.tgz"
  sha256 "fc33cb69872fdb40b897053fbf6774ebb5a732d8c96b3eaed2603ae3968bcee3"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28dbb0d7f3acae92ca63819ba0e359a0cf7701af85174c528bdbec44dd9658c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28dbb0d7f3acae92ca63819ba0e359a0cf7701af85174c528bdbec44dd9658c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28dbb0d7f3acae92ca63819ba0e359a0cf7701af85174c528bdbec44dd9658c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "20c41405631fe04819eaa4f12bbcd949323a7ae2e847a92f12bdf7c3a01531ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7fe5eb10957409cd8b75127d681b5461e6e0faf048858ca7416ed7b42eeb875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069844268fa8eec7311e114835b704f26e33088c06aaad2904546e708c3537a7"
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
