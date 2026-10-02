class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.15.2.tar.gz"
  sha256 "2a3751317fe2c1d961b8d8cb422f2ed7e8a7f1cf364187458fa39cb39bafed10"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "831d7463797334f80e027d86b395686d204a16200ecac2a4fd024d9988524324"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c0349fd31c2bc528f9e873dac0971d97c3c28b4ea800bf74f3efcd6fd3f360d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a35feba5b169ac7f481f39236bd2358656358f0f1454f616b07876051a82f8f2"
    sha256 cellar: :any,                 arm64_linux:       "f5dbd38dfc9ef69589863fc36483de79dd7ce3a9d5f54c8e7d95c6be2a3fa2dc"
    sha256 cellar: :any,                 x86_64_linux:      "361a3c6f0d0d763830c17c153362c3451a28db0ba227f4aa12980641745e6e65"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}-#{tap.user}")

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
