class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2a89aa657050a799a0705cbd14d7967e82a0f60a944b7acb27a05d9413a58227"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877d75ceaf292ab2592e0cd2ff182710137c5a7635a04a0cc2b44647d441d83f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877d75ceaf292ab2592e0cd2ff182710137c5a7635a04a0cc2b44647d441d83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "877d75ceaf292ab2592e0cd2ff182710137c5a7635a04a0cc2b44647d441d83f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7dd7f8c4f178c78d67ba06ed1d19ae80c4ac6e1ab5ced237767dc294e676f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a692386e11cffc4e20c11ef41ea5247e9407a433561d25adc6b90fdfffc0e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c68ac5f1a54b85aa45a1a6dddef9ff864cd4a75d870ef2c918b11deb4e114d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
