class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "e6fdbca8b1353501205e7ad26314384709cbc8100cd9ef8ebc83aa0bc8a1a976"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf50e2696fe26f0b7e68ef47342866a91ea6a5371f300ed6f67c733f518f8ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf50e2696fe26f0b7e68ef47342866a91ea6a5371f300ed6f67c733f518f8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf50e2696fe26f0b7e68ef47342866a91ea6a5371f300ed6f67c733f518f8ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d60c9bff02f2f8c7231aae33b31347e77d26715dbad2b1cf1d2179ea77f6a3dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85869a31e971b3bff64147fa386fd896b2d43b1e04326d63abe6eaa596b17f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996af3b296583f81eb44480cb32844f01edfb4943a87fb8822d07bff555e9607"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bd"
    bin.install_symlink "beads" => "bd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end
