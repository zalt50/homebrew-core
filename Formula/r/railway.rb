class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.25.1.tar.gz"
  sha256 "522893fef40195c8a16dfc09ef606152426db32a7a751c97e0414efac2fea3aa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cee726093c6d8f3955a73ae947f6d4dc8ec9a1f4fb8e1b3fbf403b632d31063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58d64541f10af4fb7ad94516432c08f01dc52263701add2c2d17187a67d6246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dafc391e397ba617e5347fa9694037f24a3e3be7b94f8461b693d17a181a071"
    sha256 cellar: :any_skip_relocation, sonoma:        "0177143664fb8cb224bee25ff2b3275158253222270368718f7229586c6b0e37"
    sha256 cellar: :any,                 arm64_linux:   "a9fb2548de2ac020de395369560fb3cbe46a16f245ff80f0bf005d3a32475a29"
    sha256 cellar: :any,                 x86_64_linux:  "4f90c585eac87d6d7e2937882dd41e0cb6ef0dd191536c2b052210421f54361f"
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
