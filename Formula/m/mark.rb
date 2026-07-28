class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.8.tar.gz"
  sha256 "225f152d880bbc2ed1971c8f9bdd2186e12a9d51a5b5997eccf53104b6f5248b"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0685a9752f5e90d0ef8f272e8a76bb5ac13aa48944c70a71329612ff5d09eaf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0685a9752f5e90d0ef8f272e8a76bb5ac13aa48944c70a71329612ff5d09eaf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0685a9752f5e90d0ef8f272e8a76bb5ac13aa48944c70a71329612ff5d09eaf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9a539fb0cb0c126452e401d18d787d80af1108e0c7b6fd17a483bf262bbfdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "246dd4f4bd0ff3612fd012d9fcba34497f0354560c02808c6ef967836a3b11e0"
    sha256 cellar: :any,                 x86_64_linux:  "1aa83bed7f1a417b68377b1d8802c6d6e9b412a0c309b289f915a599c0284bbd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
