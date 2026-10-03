class Lsr < Formula
  desc "Ls but with io_uring"
  homepage "https://tangled.org/rockorager.dev/lsr"
  license "MIT"
  revision 1
  head "https://tangled.org/rockorager.dev/lsr.git", branch: "main"

  stable do
    url "https://tangled.org/rockorager.dev/lsr/archive/refs%2Ftags%2Fv1.0.0.tar.gz"
    sha256 "9b54dd8b5ca3f3f61605d6bcf900137c369e01d49454e543dd3b57805b52c55e"

    # Backport to build with Zig 0.15
    patch do
      url "https://tangled.org/rockorager.dev/lsr/commit/1079dbd7fb3fc38fad127d3e5f9bc51e088762be.diff"
      sha256 "1a6ac416cef6b467dc19f0e859b0f1705dac41b4406db6f3539ed0650788390f"
      type :backport
    end
    patch do
      file "Patches/lsr/zig-0.15.diff"
      type :backport # https://tangled.org/rockorager.dev/lsr/commit/a9cfda7e53715538fe355622205d63d9efccde49.diff
    end
  end

  # TODO: remove if releases catch up to recent Zig
  livecheck do
    url :head
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4d7eca5ce1db999d5e5efa67c6e8f5b9f5f681d17ec27a5212e1a8ef4c6b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1684d5db5fd99d451a80034ac2168b7e5ef5cb22a284ae9d9c587a7fa8f435bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a27d7bc4981b7303039e18075037a0c87615c70f2cc7e63937b08a6593bed38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "080c3bbf7a9ec1cef93b734868fac72f922ab66b5c9286a36fdb61d89ffb260a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e98cfe0a45ebdc07e08b3e06157612110df9824170d8a1eae573836b70bc98c"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f894defb6f85dfb7362814e325ccaabebfd0914d0a82c63a219940c74ae6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071775094aec0e406a570dafb3d15fc0515c3277f1136ea4424cbffd1b833e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0044a4cca23cb76a32c0095cee321c50d049007a608ae54155268b0ac30a1213"
  end

  # Aligned to `zig@0.15` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2027-04-15", because: "does not build with Zig >= 0.15"
  disable! date: "2028-04-15", because: "does not build with Zig >= 0.15"

  depends_on "zig@0.15" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args(release_mode: :small)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsr --version")

    touch "test.txt"
    if OS.linux?
      # sudo required
      assert_match "error: PermissionDenied", shell_output("#{bin}/lsr 2>&1", 1)
    else
      assert_match "test.txt", shell_output(bin/"lsr")
    end
  end
end
