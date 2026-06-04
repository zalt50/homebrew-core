class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "2de601b482b403ae92b9156990c86b8d542671e783d5d84688a22a6daff7f4cc"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "221b1088e7c3b2254dbfa97319aa8276b4a290254186ed7315caf1a0f6da07f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483725079d4bbd55e27323adf9a5460e55cac426e5506d8f713a8b0ff5044449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954cc50cd432377c1762248bcdfce8820ce941e6a50ed669aa75b363897a91ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "69dee4e26913a2525f691499bf0045dd57e3eb6fc835010f07ce51330b7803b9"
    sha256 cellar: :any,                 arm64_linux:   "2df59e97e1f6b0574e884897b1b467bd8a4c9c34e09b7a8f06aaf8b8444e01d5"
    sha256 cellar: :any,                 x86_64_linux:  "71122bafc1f76ce6cd75fa8caf031c643f72fe5c10d161c29d871455fe2944d9"
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
