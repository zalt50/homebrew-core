class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.14.7.tar.gz"
  sha256 "8f5b196f518227077298c72fc5ea7259badca3047e791d57e0dac0dca0dc5b66"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b3538f7e955fd91410952c870b91b2db9fbd304ec15c6fd2d4abf6b74306222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7058f6c0a3e94b2541baa719e31dd0e1c8c465aaf296160fa07d7a0b3686391a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e377d7067cf8d2bcde491484633216096cb44cc5133ad4166577a4d6a659a92f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae85d82397d531191efdc9383128d8de011c629962a53e6f8766b5d3e715b931"
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
