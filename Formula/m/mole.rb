class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.15.5.tar.gz"
  sha256 "5b9bfed6bf02d1ba9904a667af0930b871c40e5aed37e1530afe1d22e8e93d67"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d47415a65360a8d9454255a56219bd34009a290d28d9cd903087aa0d0eff32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8c24123e51b8b6c6765d2d45af0265af22206d1e2c031b272d7768604e8762b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a483ae66e0f29f8c6402b60acccc0b5ac73749dd9137fb084ce02fc2622304d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85f4851a949a9569ec8d4be1ff8f4e635f42bcbd7841392a8856d1e42c57a50"
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
