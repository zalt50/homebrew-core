class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://github.com/google/magika/archive/refs/tags/cli/v1.0.2.tar.gz"
  sha256 "bae42b31c8f419f34043cc2cf26fa42d2ade7f7c91e2fb54919914432f799699"
  license "Apache-2.0"

  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93f626ec1454d84cbc0b52e6e5c1fc1eb8552a2cdc29677a99a96e91b1e4444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f3471c44e457082fb3a995f41069cfba54a49dab6394c28342b807edb7c954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "388505c16689f93648258a297ee037950e3caa83f1fa4f07f50f2e688ab00866"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fe3680a0f5b6f8256e96ae53eba014b798db39a2d9ea7656dc55a94084e3bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f13de23f78e84aa077b96a4aef51865666ac158578472bada2bb1fbc8c5a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9010cda89964baceb390e0121198c0a9c55729455affeaa83956b3f290b0650c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  # Fix x86_64 build compatibility for ort/ndarray, upstream PR ref,
  # https://github.com/google/magika/pull/1312
  patch do
    url "https://github.com/chenrui333/magika/commit/f56ab8a0806c67a2ae87edc6cd032684d592b978.patch?full_index=1"
    sha256 "7a3f701733c4df5ef0aceba3b7854f1d8e0f2a23c4fda95804911b0fa5e6ab9c"
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end
