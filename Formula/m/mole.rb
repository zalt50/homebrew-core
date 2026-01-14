class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.21.0.tar.gz"
  sha256 "1768b2ba21938a7b9b5a9990b589767364a0e048d2603031e8ee357180c21981"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4834d444d377802f68fc80a9011a80abc5174b557e899542e367eab0f3befbf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "054a9732a9c93ca43858a4e73d9a07269a6be9453298908fefe6546331d71fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d6a4b7c90a1c00cf5f70b4884b9f3260468e271e76ac219026b32a03b3b99f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91658062844214f227e237a0a0a7a0471c6a05b1dda950bb0860c6ada43afb2"
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
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
