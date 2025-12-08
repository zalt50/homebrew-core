class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.13.0/sigsum-go-v0.13.0.tar.bz2"
  sha256 "5c34bf885cb41f10879f017cc6de910e0ae4a4abab9416259dfb478d08e4ea54"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fba359bc438deb1423d8f4dde8d68bc2745bfd827cd37330dd6e2753e74e295d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba359bc438deb1423d8f4dde8d68bc2745bfd827cd37330dd6e2753e74e295d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba359bc438deb1423d8f4dde8d68bc2745bfd827cd37330dd6e2753e74e295d"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a44d8f435352755d620611daaa09fb2a685ac31cef08b074c2c86aa3f0656a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad1cab5007dc13348bacff6f90da96f92809e99ea5c88242c92874f0e3806ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc999cb39b0b8144e60c2d61ede7cd8a18ae8d64167a6e461d63cac356bc8d02"
  end

  depends_on "go" => :build

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: "-s -w"), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end
