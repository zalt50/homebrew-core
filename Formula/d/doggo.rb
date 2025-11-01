class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "bb66deafb34547c4e2735908ba5c42c6a0c5f30fb2b62dc5f9ff7a11fbe15d3e"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a266726e6f93f4646727ddcfbdb9c3e0c5ba51448c4a4a104f960fc22c248c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a266726e6f93f4646727ddcfbdb9c3e0c5ba51448c4a4a104f960fc22c248c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a266726e6f93f4646727ddcfbdb9c3e0c5ba51448c4a4a104f960fc22c248c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9d03a814577a28f5f75d277d5d6fdaf4fc335de14c2faa44985445dc19e8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e57d986e9ff91e3849c23a37f18b82c64da4a7aeb476df15b2ce595b4585cc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181bd9737a7cb0dc7ca01ffb3145e170380fe225ab059db9f9168936fdf24e0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
