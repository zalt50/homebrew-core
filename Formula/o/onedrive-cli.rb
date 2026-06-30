class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://abraunegg.github.io"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.11.tar.gz"
  sha256 "7a9cfbf1cc20c8e157dd028e819ec14b9893c158494b9744708ace975076f995"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "92182bc0cb84b68979e587d13c54a2fe7255ac3d08ffe14a12cc950c6a35c98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a90b93658bb9878d92bdddd2ced2ca4dbc99396379129308a149a7d5a458fb40"
  end

  depends_on "ldc" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "dbus"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

  def install
    system "./configure", "--with-systemdsystemunitdir=no", *std_configure_args
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash" => "onedrive"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
    fish_completion.install "contrib/completions/complete.fish" => "onedrive.fish"
  end

  service do
    run [opt_bin/"onedrive", "--monitor"]
    keep_alive true
    error_log_path var/"log/onedrive.log"
    log_path var/"log/onedrive.log"
    working_dir Dir.home
  end

  test do
    assert_match <<~EOS, pipe_output("#{bin}/onedrive 2>&1", "")
      Using IPv4 and IPv6 (if configured) for all network operations
      Attempting to contact the Microsoft OneDrive Service
      Successfully reached the Microsoft OneDrive Service
    EOS
  end
end
