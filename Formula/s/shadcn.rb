class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.11.1.tgz"
  sha256 "6df62203e639b3c9ec10e50f9f9fd057c4df2ef9ccc3f434dc07c405b09bd102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b9f3b13cabb66acb1b0e4dbe45aee4f49fd76fce4132f6f026edfbcd0ed4077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9f3b13cabb66acb1b0e4dbe45aee4f49fd76fce4132f6f026edfbcd0ed4077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9f3b13cabb66acb1b0e4dbe45aee4f49fd76fce4132f6f026edfbcd0ed4077"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f7721c62c2f9c350017cdbe35ebf930c981dfd2ccc3abd5f40ce7da68cc077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3430e25b661d47009a2523036a56979c522a418140a177f4a37a0c45fbaa7763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3430e25b661d47009a2523036a56979c522a418140a177f4a37a0c45fbaa7763"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
