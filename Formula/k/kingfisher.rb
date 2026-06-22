class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "c87b4020aedf247884a9a8f60234de669490598272947b8862783efab39a56f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e01aea3ea8950a392e59f8a3ba0f8d4f14c00bd8292cb3eff8f5b449143acae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389004db079c2609364d51f7b05e76f9cb12f92db92a6c066934bb82f2fd8fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c71066739f23c498773100034df1fa5337f5e2e5aba382357178e8e0b7632473"
    sha256 cellar: :any_skip_relocation, sonoma:        "93cc674a007512fb8decdbc859a4ca2a7989c55697098d9ec32c592794f29d19"
    sha256 cellar: :any,                 arm64_linux:   "331572010a99c729c7d2e82e7fb952f2f44b0b8e74a8f98345e1fcb67c779432"
    sha256 cellar: :any,                 x86_64_linux:  "bfda91d0279796559ec50020447bbc6c820a625ecc7dd86f9db9bc8f66f3617e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
