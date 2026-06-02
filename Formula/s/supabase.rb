class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.104.0.tgz"
  sha256 "693df8c4d3d559a5219d190e75f08735f96d64a77765f2f06f6662f4c17f5e88"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c8d776618a5663229cad007f9d578fbcbe25b61655ba959739ffd0c67a4ae63f"
    sha256                               arm64_sequoia: "c8d776618a5663229cad007f9d578fbcbe25b61655ba959739ffd0c67a4ae63f"
    sha256                               arm64_sonoma:  "c8d776618a5663229cad007f9d578fbcbe25b61655ba959739ffd0c67a4ae63f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb494d5fada61d4ab0788811022ef6bbcbba3043a281205f26f943116c43c887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d3027a7f6e70a653a7c7144fedf4012833c03bb7d9f454e284638c293420956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4f5cf7666f228bdb9e56f2d2f6d1c19e682a870f8bb23501f3453c6bc3884d7"
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
