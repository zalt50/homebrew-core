class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "530ea07503054ee614104d6e45938de77ad2848ca1e3121029efbf1298a8d3a8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7c91be62ef8ed9950a8b4cbe7d019d916b52144b1f37221a2c8b2e5527a4464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9487bd093165531c0208d5941a34ce0493285e9447cea6e8416450d76adbb7e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617205b9663846967c767dcdb756f44f648d36abca5e73e4ad2c0cd4e4cd43b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac592570c31b930d310b152a28ade0f0dce4f59b46d6dd43b78e94543c33d5b"
    sha256 cellar: :any,                 arm64_linux:   "7be2f027677d73845819e79262b870e8c6ed328d03974b36b079573939a559fe"
    sha256 cellar: :any,                 x86_64_linux:  "f27d675415ba80d753cc7dacd7228bbf43662d9c9c7c9c908b94b5a15d4d53d4"
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
