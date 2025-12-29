class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.16.1.tar.gz"
  sha256 "ca5b3307867b282194a3237fa2ee408f6dc4ef17b71e1ade324d87c4a0ff15a5"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42266678ce268f0f118c1144a1153773995f23a56ee7f8deae3d7fd692edcf0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7b3bec893f368ef9a05156eccb2987b140aa04a565e8727817a2806a8333c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a7d5b4615722c5a5694e53e2f010f263d52908d1db8f7fa2919beb9b483116"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdf93630e6c5080f6275b6b36d4a00f52a7722955cb619a2d2da1ec66e9fbb8e"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
