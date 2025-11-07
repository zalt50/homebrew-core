class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "3426285a22b1a8aa5b63d47dc1447cb79dbf10fb7c9b9ae7a9e345e8668c9a59"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ef506eb14433cbb32d570e89aa8ac424313974f75462e704026d22ebb3177c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285079708b366f449480d6b6897fb61eb5e557b361a6114cc2c014e4c20313c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f17049f4369e2443990b2199548941c433ff4cff84bcfbfdd560008bead67487"
    sha256 cellar: :any_skip_relocation, sonoma:        "0232487c7828e621166782af8703456d8b39205ba2df7f0afcbf05dd5456927b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44a124faef01afc7e2c5ae3fe46dc5166443db13bf63c35f252ee544079e616c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01f290d365fc27d648667a7d7b03de14a47f6d53b01a3b73f9df689456c54fe2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
