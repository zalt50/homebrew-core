class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.115.0.tgz"
  sha256 "97559fe62f73e476609d349f85ca0a4adc6a962080b127b0723e03bed83c5029"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0fbc66747068670a1fef234f22f66e6b7119d5983cc8e47ed5047219347631e6"
    sha256                               arm64_sequoia: "0fbc66747068670a1fef234f22f66e6b7119d5983cc8e47ed5047219347631e6"
    sha256                               arm64_sonoma:  "0fbc66747068670a1fef234f22f66e6b7119d5983cc8e47ed5047219347631e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d199cb70916b0033e2f1791e99c1387fa95f6a77030c839207d25288a784ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367e49963ecbe81a3f69542855f9cbef0dce266380ace08b9232c5a1207de67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c27feb91f6e4c6fcd480a0aba01db699b6630f7e8365238c096a866545b0a5"
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
