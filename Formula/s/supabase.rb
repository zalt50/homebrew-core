class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.113.0.tgz"
  sha256 "cde97e29dbaf2ef89c61292edf296649bd4a5fd14b3620d7c8c7068b0a9696fe"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "662bc0dae8c2f11a51e5887e6ad6c3301678ab20ad21dab176d5a0f14917a933"
    sha256                               arm64_sequoia: "662bc0dae8c2f11a51e5887e6ad6c3301678ab20ad21dab176d5a0f14917a933"
    sha256                               arm64_sonoma:  "662bc0dae8c2f11a51e5887e6ad6c3301678ab20ad21dab176d5a0f14917a933"
    sha256 cellar: :any_skip_relocation, sonoma:        "d828099592cd76931854787c1b120242824dc51cbdca766e5e3aa0e0bfcbea0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e30a742b6c73fa31590255c62b4041d446ec6781d3233bb80b138a716f5e8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bbea9c0188e83005711891f884e53cf03da0e126e51ca199facead8b3ff84e"
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
