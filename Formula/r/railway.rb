class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.41.0.tar.gz"
  sha256 "2f7293d1d78f7f6d5d2d9c301246b84c6ed92b3c0c58fd9637e470470dbda53e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0858a1fbd454fb599c2ec9b3e3434b2028f3c8ce608ebe437c411499f84f5f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a582f630bbd9fbceb7ac72614e79d2520fa016dbeff0a918413603c440140bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51960455d3aec09d40f3f2a74f6a5bd876d991b3b473e1222cd38035576212f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7595a0a5340ae73eab2f1e86817a47afb6de03a08459326fbb4fada789b7c7c7"
    sha256 cellar: :any,                 arm64_linux:   "857fe1a8dc9173cac7884f159af37ce26a95d674cf86ba24eecf201d9847be6f"
    sha256 cellar: :any,                 x86_64_linux:  "9dc558535b7bc4eb44af04db32891e2a3caa8a65d2c733c263c5029fcfc570bc"
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
