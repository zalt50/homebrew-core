class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.108.0.tgz"
  sha256 "67802326e937ab4b97678c4db1bcf75052f4f96b91ae3d2c361719eb0f1b4e3b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "593be084631f88744c66446b799ef1d58ccc163a61542dfa7cafacc7464b52d7"
    sha256                               arm64_sequoia: "593be084631f88744c66446b799ef1d58ccc163a61542dfa7cafacc7464b52d7"
    sha256                               arm64_sonoma:  "593be084631f88744c66446b799ef1d58ccc163a61542dfa7cafacc7464b52d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e69d88fd9c18cb45df4e3e06943bc7d62e1e19623e21bcac174eb0f77d01a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68164999bc5a01e8f60aebda2ea0cb703bd44f74b317c29c8c20a038b9ed8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162ced42809f5ef4b9ad8e9a8a468db48f5cc94164d970abb9db66a7c508828a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
