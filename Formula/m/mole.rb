class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.17.0.tar.gz"
  sha256 "327717e53c4d61d4a2f076b3f9b8dc9f79f2d95c1bb135d38be0110e38bc6089"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bbd9a5bddb499f1c396fe65cf56bb6815b037b679bae0458c4de9ed34427162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ffd0a673cd6b6fa48af211dadde2674745658c5ff2f2addf8223b095ed5d1f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f833bd0739faf9f219bc9e8473a53747529231a8e67b6268a12a5664b12006"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc294a50086012defb4f5c9feb21c5d810656ae4a356de0696c79dd0e62b61c"
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
