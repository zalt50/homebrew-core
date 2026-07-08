class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "def64b66c47dd38d98e37bfa1b571584ed9ab5f98be0dce09304c68b7ac966eb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1a6e3c8700298bff7e1cc2e7177624d059cb7433a61f0a763493f455611603a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a6e3c8700298bff7e1cc2e7177624d059cb7433a61f0a763493f455611603a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a6e3c8700298bff7e1cc2e7177624d059cb7433a61f0a763493f455611603a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b822fc54b082d818645c91d411ae63404cb9dfb2a13423e60b272bfe020708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cf715334fa5c5c41db88569bbd69b17a9e407718d8a72064822feff4ef14cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740331ca23d4ef0a12ee206a7ecb140841a0623a8381ffcccce9dadde40e4938"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
