class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://kubernetes-sigs.github.io/cloud-provider-kind/"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "87a8c713be6b0635f7cd32832c40a929afd93ddffc57a03076a7574bd7dfc43c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f78fbb68e95a5c7f9b0a451d174790ef8230d87f4bae25c8003f5a17fac41db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43537aebce6e02f408badd28e35cba74c8ab40a81cf034726c411ac46b633fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20cb34b99c77dbe10de854c66d2cfb3ef6f428d59aa36ad42bee74cbc44ad5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "089bf46b453010a0eba554529c9583c3dded671f36ec4f3ff2f7bda01b4b48fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0433af04fdefd5f0916438a4f9e45e32766efd6909ac2b66ad92b831d1793e3a"
    sha256 cellar: :any,                 x86_64_linux:  "01fc94859870851e6fa7a7181e8da67e9df2b4257be5bfa6817fe1848dfd50ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"cloud-provider-kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 1)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Error: please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "no supported container runtime found", status_output
    end
  end
end
