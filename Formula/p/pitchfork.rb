class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "733fb535e25a053e022e8a2ec2a4de1cda2a47dd918fdc368c4782d6fee3e83f"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4291655704a76f1788344c0dd5b30d9faade9524802d3d3680085edce7f74d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6754cd3c161e819b155136c652d00f2f0f50622e35304aea557f57bf8c05acbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93089c675e126f010aeb93ba38fc141df5ef83b913912a5aada33f5d9857d498"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fecf965539a81d3630fe4aaf67b5df4bc71ab3e923627327e537a173c89830c"
    sha256 cellar: :any,                 arm64_linux:   "e6856c2e153713988349795fc97471065204d641ac93b01ecead9fb75c8f0ae3"
    sha256 cellar: :any,                 x86_64_linux:  "69d4c45c984a8d5fb12abba5d9c5486c7993ed679080d410b247dc4b4e5067b4"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
