class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.48.0.tar.gz"
  sha256 "6a8274bb7e5242796d9881b43ef925521576c4d7b07ab3b3b94071358f5ea09c"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd7bf2d6c95b6b9f22a5c7cc977a8b5b61618a99c1c71c28ecad3914106f5c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569504d117f6136c75a1816927f19ed53eb80c139cbe295561f3452a0256c6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea91cb94ab0763ff9213c8e4f9fc191aca469f24edc2fdcdfa38ae368953a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4b3012d277d0035050cf2bf38e18f6328895b38c87635fc009d3894a34e9915"
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
