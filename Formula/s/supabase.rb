class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.105.0.tgz"
  sha256 "6915a934748bf1e532de2e18a473da340fd277399e4670358bab479da1c67064"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d1886c583bf1bf109782fc5d85b07e467858889188db77ff12d1007ece30c247"
    sha256                               arm64_sequoia: "d1886c583bf1bf109782fc5d85b07e467858889188db77ff12d1007ece30c247"
    sha256                               arm64_sonoma:  "d1886c583bf1bf109782fc5d85b07e467858889188db77ff12d1007ece30c247"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a85089ac9ec4aff87138478bb69df60cfa0e56738b0302a72bdc2d1ad86dffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde3a734137edb3da9e86ef156c6423b1f54e8bd3af4c859456b7426c85fae8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1c5fc383034a66002b76be34c64d0b2607267a81a4cb3effff17b39d75b8f7"
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
