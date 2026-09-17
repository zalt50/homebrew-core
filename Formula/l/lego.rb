class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "9735d946aa00522764d08fb56c1483f2da42f0ebd0bc1eebffc35e4b89c289ee"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af41afb69869435f568c1b474681538c9e415ba8683246b372c1daee3678c9a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af41afb69869435f568c1b474681538c9e415ba8683246b372c1daee3678c9a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af41afb69869435f568c1b474681538c9e415ba8683246b372c1daee3678c9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e00edec51b8e0dd01675a242db84a62ce544ab29da12914e635e3ee12f8217c"
    sha256 cellar: :any,                 x86_64_linux:      "b9297a4378b876ac9abfde3141c1b96eb797186c294afb3882097e13c34c4412"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
