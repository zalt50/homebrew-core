class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.0.tar.gz"
  sha256 "293db51df95c2641540f7efb9d5d5e12fabcc70034fe9ad510bf9b158924f001"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80994e7d1ba41dbc10dd534a2c61afd68c347197a152455cf555bd3749d9a95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1137e33677aebcbbe055176525f13a9c8b983a9acb46bcce45e2fc168635f42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4154aa3dbfb51931115fc74b3447e35d2f1ce0b3989faa99cc0023cf7796d73a"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc48c61601ead126bd7702aed108dfbdb4d6f4d405d9c818b9858677a5327fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96e902a861e47277f298df4e4cf5ee63d31cac6d3265a5eda1e5f78a6302185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2b50f4ba9fd803b89ac50688d2643a00646c42f474bef76bb287e7549dd3cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)
  end
end
