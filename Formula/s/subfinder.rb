class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "fab71430b869ee26d4a44cd2b0685b80bd61326a9cd42925247f6a8eb6d4c4f7"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5a755bd5f06e480aa88f936ea46e81688cc4ea25776d71b1718fa54dd3fc032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3057a6d0243fc0c6e7712aa4a110eaff53a8fbacd846479c4491a0ccebe3282c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eead1297d013e9582621eba4f7987ead1f602b22e25d596f039ae2f2fd38fad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a66ac1e8285897ba49da131b01236515adc87a82b0ede48025c73fecdc89ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d0e1e42d13724183619807395b0f9d668590066fb4b76d2dcd2709e44cc2c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685ea79eb23417b8ae38f78e6ea36706e41a76b7b60fd752844c4deaf524b941"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/subfinder"
    else
      testpath/".config/subfinder"
    end

    assert_path_exists config_prefix/"config.yaml"
    assert_path_exists config_prefix/"provider-config.yaml"

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
