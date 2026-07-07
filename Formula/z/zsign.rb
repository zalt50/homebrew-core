class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "84cc3458da2366f88cb87da87ddeed9c0a903c716d2a891aa09cc14e0a74b7ac"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e86b79de3dfc725d5b2b6fca6f0a62f6327a0c7a8aa46784da83dd4857e3d415"
    sha256 cellar: :any,                 arm64_sequoia: "3960908b488c1c7fcd70d3020ec58fdd5760e60c622a16717b4f8f86b33bdbdd"
    sha256 cellar: :any,                 arm64_sonoma:  "823a58f6acedd2fbadfb330f49cd97ea409e9b87147e56de00bf0cbd4db4b43d"
    sha256 cellar: :any,                 sonoma:        "f606b907af409419b88900bfb0dded42524728b0303fb62c3258ffa0d05ca68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9feb3d7680b5f31e02a4ff3dc5beee8857f54f1f9b16379545aa04ea68035f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4a2691982f153fd33af6c96605d9a4a54574fcbfd01ea19c59c2c91b5f3561"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  # Build against OpenSSL 4's const-correct X509/ASN1 accessors.
  # PR ref: https://github.com/zhlynn/zsign/pull/400
  patch do
    url "https://github.com/zhlynn/zsign/commit/c39607e4231bceffc0e4d7c1dc257ef67dd3c5b7.patch?full_index=1"
    sha256 "dda8e0a6308cbeb8190f349ffb8009e887c9c1053b2a30d1bcb78ee3d6e57d8c"
  end

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
