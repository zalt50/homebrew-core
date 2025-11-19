class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7341cab86654a171a427799f9e472696dad17215641c39c4b26de8d2181933a0"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3b0400c02eb8bef6fc85a2db02744ec74afb8aa1db72a3bfac81d36978b5b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a64b4b74c47d94b2a31a4aab6e2c32615e9799956e9116bc478f6e875d67ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f63719b5741c4cc6333597c5be30875dee8bd18d0234def30be591b6dd612b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7fa82a5531eb02c656bba36423b6a6d8434f9857be2e92e8c87375d952c91a8"
  end

  keg_only "it should not be in Homebrew's bin directory, which is often writable by a non-admin user"

  depends_on :macos

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"
  end

  def post_install
    (var/"run").mkpath
    (var/"log/socket_vmnet").mkpath
  end

  def caveats
    <<~EOS
      socket_vmnet requires root privileges so you will need to run
        `sudo #{opt_prefix}/socket_vmnet` or `sudo brew services start socket_vmnet`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  service do
    run [opt_bin/"socket_vmnet", "--vmnet-gateway=192.168.105.1", var/"run/socket_vmnet"]
    run_type :immediate
    error_log_path var/"log/socket_vmnet/stderr"
    log_path var/"log/socket_vmnet/stdout"
    require_root true
  end

  test do
    assert_match "bind: Address already in use", shell_output("#{opt_bin}/socket_vmnet /dev/null 2>&1", 1)
  end
end
