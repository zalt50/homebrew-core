class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-2.0.3.tgz"
  sha256 "43d64a758edd3fdbe2e14676baaa7ca8c2c2fa475509bd775730fa30b15e5d7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3218169d913af53d9465a82a3d9c7cdd0a72c025a2bcb788a5846d5a999bfda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3218169d913af53d9465a82a3d9c7cdd0a72c025a2bcb788a5846d5a999bfda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3218169d913af53d9465a82a3d9c7cdd0a72c025a2bcb788a5846d5a999bfda"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d6f7da45b9bc41947937f908f1f6e48a740e74931da134683e90bb5fe63e33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d6f7da45b9bc41947937f908f1f6e48a740e74931da134683e90bb5fe63e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d6f7da45b9bc41947937f908f1f6e48a740e74931da134683e90bb5fe63e33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
