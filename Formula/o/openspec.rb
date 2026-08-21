class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.10.0.tgz"
  sha256 "fefcf1b7d1e38cf06a3279c6245170dcb0d261d8d6c8ead3f3096b41f4b971fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60958b71b5e236e16b8ec4ca090c5337c0eb651dc6b9e50d53b66b13028a2614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60958b71b5e236e16b8ec4ca090c5337c0eb651dc6b9e50d53b66b13028a2614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60958b71b5e236e16b8ec4ca090c5337c0eb651dc6b9e50d53b66b13028a2614"
    sha256 cellar: :any_skip_relocation, sonoma:        "263344c7842800984709dc950c9bbd0f3253c37e4933754e9a3e5673fb9d2932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263344c7842800984709dc950c9bbd0f3253c37e4933754e9a3e5673fb9d2932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263344c7842800984709dc950c9bbd0f3253c37e4933754e9a3e5673fb9d2932"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
