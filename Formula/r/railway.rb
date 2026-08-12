class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.37.6.tar.gz"
  sha256 "e0fa319a058619d742873dc89ed805c4d22b02f44fdca37d6e6a49de75303871"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23a57ec0286c34b132276c911ab8eeaa20f09936c4b23b0ac4a472475dfc3821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd31ce9f370b1e99526c500c9908c2b1a8a0f9893751a8dfd52f53c5e30ad30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d252a3b62de38ebacfc0638e45896afe8db65ec758b6d019b2d8b6e09497ece"
    sha256 cellar: :any_skip_relocation, sonoma:        "5679b4723e20d618a8aa79f4324f406ea6a18180dbf3aca4128718371e28ab2c"
    sha256 cellar: :any,                 arm64_linux:   "801a0385f7c325961c362d33add10002a413ee994c4dbb59fe6b24e90ad92f9a"
    sha256 cellar: :any,                 x86_64_linux:  "4c6bbcb69890fca5ab34e6d691b7dc5d289d6a8e9e0b5a04add91a2acd30e4da"
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
