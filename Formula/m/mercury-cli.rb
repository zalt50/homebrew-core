class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "7545ee98100a49de749d20c9e47a4dfb8988a286077ebc4e8c014526b64d03c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e78fbba3b09133f90e80d3ed27ef648bc4f70df88d0414b0a2674d7d72eb42f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e78fbba3b09133f90e80d3ed27ef648bc4f70df88d0414b0a2674d7d72eb42f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e78fbba3b09133f90e80d3ed27ef648bc4f70df88d0414b0a2674d7d72eb42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "241210b628c169e56eb4a694fe713222cc4a2c7b090a199cfe0d60cd3f4e2dcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8058fc73bb2b913f3385574f3f2cad7634387c64e8542404df05bb5ec9edac2"
    sha256 cellar: :any,                 x86_64_linux:  "3e8ecefdf499305399d8b1054400358b9082395e626da08a467ec95950cc8de6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
