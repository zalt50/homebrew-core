class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.304.tgz"
  sha256 "7c1286429019b7478cc3d773303b3613835a81e36aa4cdfbaaf4da1b4bffda1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2479d92b098d8544d797902430ddb488d377b9bd70f38091536c034c2c4b70dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2479d92b098d8544d797902430ddb488d377b9bd70f38091536c034c2c4b70dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2479d92b098d8544d797902430ddb488d377b9bd70f38091536c034c2c4b70dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f929faf13925e126d4f75cf0d564a9d5fa60f44a08c1f28fd17eb902cba05d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d24e336c2ff74444598f2f538730150e53171e959b66eb859a5cbb767d8fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2915f0bcbda99f457ed0fdd824eec5b9e91b567487e37b9c7fe9c0f9569f98a3"
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
