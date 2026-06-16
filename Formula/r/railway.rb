class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "f44543400618bf1e7d28cc3d4cd533b79bb6962370fa15537c08edd31663c91b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5cd6f2f28652e3843fb7e0336d97919b10a175a7beed3c01f918c73d54f85e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879ecc3c5e6828c886931f8a23e41170fda2a11e03315d5ce0ff0fe3f2510b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e934dc785d4e84272260be3b707eb881c5affb698209ca63ff4b60c545228ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbfff0503ba7229047440a47e47e8362051176a7e39af13f5ae72c387e7d6cd1"
    sha256 cellar: :any,                 arm64_linux:   "8f4be418886c2eea082376796fb39ec8e8f933ca2ed560f8c68ecad1d7573e22"
    sha256 cellar: :any,                 x86_64_linux:  "22feea60f4a3a3ab16b1cb288f47bf12354696cada0a20db1f48f86b69725716"
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
