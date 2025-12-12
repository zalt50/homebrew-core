class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.3.tar.gz"
  sha256 "80dc408a4215d80d12eb8f00067c3e578691da1e6e78727153efeb2b397942ef"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f777328b2031d35a52133201415c472c57d28ce0b6f03c811f77e0de945c6980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008a29274dfb34b81490f548e613f84fc7bca5ce5f438a8cd096c8777af8b59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f3389d2d9830bfaadbc509a3b60bcd8149905d2f49102f8446d6f7b9b8a1ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d908231973bc5755ae81d573ededc3770e5361c1dfbcbf6bec93f74626d0b02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40b9cd17e17e3345e193f3c767ed42e65aef74d9d37833e09f467e48c3fa1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438431943226f6283c92ad78a77bfc0d2c79575ccfbd5b93ac16ce5c32133687"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: unable to select a 'profile', nor any AWS env vars found.",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
