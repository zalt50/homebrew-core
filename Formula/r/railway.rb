class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "7e9c443df9e02d4095501d8d6d4c43a8f32f5c9239350c5d833c7be00a69743a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad6f93ea69f2b0e893ce71db74a70eadfe8750de853c31d94648b22364eb0e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4039f1877334f1e1e80200067716ee2a69bd7c5fd2aa0f4e608d3d3a34254c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "859959166eb6999709db08024380e9260cbdb7aa77f710e72926fbcd3eb44382"
    sha256 cellar: :any_skip_relocation, sonoma:        "95cfd84d9bbe74318cb2ff456175f0a1d23280377693ba3b3d67279e02707779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e36cc93f3addcc0013e8030b6068c71b7ba6b2e3d66187e62d1fcad20fbf655f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7185a859139a968d5bed5b5f9fe86839f44926595f1f9f76f70c587034dc19a"
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
