class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.49.1.tar.gz"
  sha256 "1bc87b173960b2bb5d39c26333403cd52f7d9caeffb6e43f2f44018fa12515bf"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea405ab3384d34c8c6ef8489997aab4f696b378125c80044eac8306b1bafc8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22f7de4fdd620143705f10cbf7e2f6d0497b686de0b9051f3d4c29a1ce7e735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851aed3cb232a0a1dbee3b4843123bc49f81abae7a8af4cc764f4dbc926fc1c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "754bf652ce3784bf5d72b490cc26b72eb72c564233add60a0b2d901243ede4b1"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
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
