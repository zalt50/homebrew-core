class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.101.0.tgz"
  sha256 "86fd9bceb780e178a2d7906aecff64ba05fe62b20248f9782f56ced8e64fd334"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7f8802a2daeb029ac6f5db698077338f154f26ba7560ff63ef65466e3d06a4dc"
    sha256                               arm64_sequoia: "7f8802a2daeb029ac6f5db698077338f154f26ba7560ff63ef65466e3d06a4dc"
    sha256                               arm64_sonoma:  "7f8802a2daeb029ac6f5db698077338f154f26ba7560ff63ef65466e3d06a4dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3109b3a0616e74668cb49b2e92080005b454d4df85b2b3b84dc6a081f63a75dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ae8f1e0869ba222e08abfa7cd8f4c593d513f8c94d1631bb430bb92184bd94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa254902dcc684a27ea6e68c1bd9756bb6a3149fcf55dedbafd25510e683815"
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
