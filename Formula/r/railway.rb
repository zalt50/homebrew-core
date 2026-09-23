class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.61.0.tar.gz"
  sha256 "7e1521282e4ecd8d25269827c171088bf5f17ceabbe2916ed125ac262a306749"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4210064ba017c7fe9b5461bab467a409c18eb948bec37855b295d94a03894a4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "247424204389cea45dcbc0ad82a1eda663007ddc322cd8c3362aa025ced2720c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5d0198d53a932aa560d2f45b632687d8356ab072bb949c5b019da00e82277a3"
    sha256 cellar: :any,                 arm64_linux:       "bd4e21f05e7130f243335a2c1160e14bef81939a58290d701fde0d46ee37894b"
    sha256 cellar: :any,                 x86_64_linux:      "3cc3ef67efa0f7fc4265d7a59c8f2f514679d45aa3aea705ff39f32f238179ae"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
