class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://kubernetes-sigs.github.io/cloud-provider-kind/"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e9448dd3460106fd4752fedc9abf550c5680dfbe3735fc2217750efe34c81fbe"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c9a8248d6c8b7b94c81abb21d2595527ec32a8bac75ac5595476bef075feb03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71abaa7663200092f8b198f09930bc311b811be957e26adda42b818d069ae4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685eb50040567782880926ab4b29337b1f945ff8db7e1532a403eae1b2ed2c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a72446756aa5a41f10a1ff78861b6630ace289acc0896427557bf8884d80ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0380652e2cba6d08efbd5a1f8c0bb8c7134e2fe92627ca67ead13a04189ff66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea290e4546708f40d79a226969f39b33387e7658d6f0f736d375737cba30bdf"
  end

  depends_on "go" => :build

  # Error out instead of looping forever when no container runtime is found, remove in next release
  # PR ref: https://github.com/kubernetes-sigs/cloud-provider-kind/pull/431
  patch do
    url "https://github.com/kubernetes-sigs/cloud-provider-kind/commit/f8b7f65c43c1d6095429186d2135c6e4905a2a42.patch?full_index=1"
    sha256 "2c809f5a5da87c61ad061f2b94586d9ab55943c9e9ced064179c872327b1e587"
  end

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
