class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "4cc89732b2fa4fee07b2db5ce4cf325577fd195995e70e11c86b9bc1a6a2e114"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54f451eded0361ab9eafc767de0ef0bd214eab7b631d908acd7f582f748734bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0527b9ff6599332a6abc75ef44c55034ded445d541d065730693b174b9fd1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c0755be7768e10cf94daf299af2e97dcf7bb86218e7e8d101bafb70863ddc3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fd561bd4037220f4ddbe46b0dbb180f07fff1a3e0748138ec8b562b09c417d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a351ca19ba53e2458aed1c1d5e3817c112a46d5ae5a5c881a16e218aa3ee00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a774b26d639179487493ebffc78384872c334a9b25cf0c76ad7fd317e71fe72"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    assert_match "could not find repository at '.'", shell_output("#{bin}/gitu 2>&1", 1)
  end
end
