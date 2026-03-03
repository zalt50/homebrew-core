class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.26.tar.gz"
  sha256 "8fab751b233aa2de0606b240681ea27fcd5481e43d6ee3aacf643ac7ccd6ff9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d2325ee073a4166c6643c60a9ceba7450fe35f27c0a74363eaeddff6f8713e"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
    guest_home_user.mkpath
    ln_sf guest_home_user, prefix/"guest/home/user"
  end

  def guest_home_user
    pkgetc/"guest_home_user"
  end

  def caveats
    <<~EOS
      sandvault's guest user home directory is #{guest_home_user}.
      These files will be copied to the sandvault home directory during setup or rebuild.
    EOS
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
