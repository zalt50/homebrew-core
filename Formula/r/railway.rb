class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.40.0.tar.gz"
  sha256 "0d4725a74960fb2fa680b57192e9f3606f4c4898b4d1ab55bfa790cb2a85e834"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01210e2097cbb76e095e7f8f9e816596cf3857e9d0897135a06c7a639ad1d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c408f3e0b0fba8befdd52a80b6c2959cfe763571cca523cd2a455cb7c796d31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7073c1ad14a359250fd260f4f4119fb6d91d143a50d25df38e93724c4eaf50f"
    sha256 cellar: :any_skip_relocation, sonoma:        "03d21856b17076f06b3b5a18d76ef26cf67923f998db1ea5cf3fa162e7153d16"
    sha256 cellar: :any,                 arm64_linux:   "04864e06925512eafab2c2562cc6ef14549c8f872afa331ee3248b1720a4b286"
    sha256 cellar: :any,                 x86_64_linux:  "99b4c4867087af5b5530433ffa839a5bff49459e921b05cf88ef1c49309dd324"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
