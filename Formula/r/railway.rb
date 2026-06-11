class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "4bcea4c8b24231e4908644fadaa27502bb351bc7fb2d63fd7be041dd409a47de"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5514312ba356ffaf46801f6c98c812d330d3201a190a9fc02c9a53dbd6973c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28bd39713d20844f01b3484403762d364ecf2b08cc649e0fcc1a6f95e34033f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a6635d83cd25d89e373837c8bfb16fc8c185a200c836bb16a07a69580420bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "33def670e99e109f044b1fda6eb47f071b14bef9136f1f501dec72b21c45bf00"
    sha256 cellar: :any,                 arm64_linux:   "16f759a6caef918d9d3d7a68d26835a071e1dd31b11540b50033299c0c33f71c"
    sha256 cellar: :any,                 x86_64_linux:  "255983ddb25bac1bae09ed72bb7f0ac9236022ce7b5c98b015c36cd634684ba4"
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
