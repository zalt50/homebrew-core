class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.13.0.tar.gz"
  sha256 "1d90e73957abaf84cf9ede427c0297f62e3f9a589add4b4dd9171afa266b5971"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097c2f59db4c05628f8c3c3a3807566e672b1830ab9252b6b338fb73f124c422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097c2f59db4c05628f8c3c3a3807566e672b1830ab9252b6b338fb73f124c422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "097c2f59db4c05628f8c3c3a3807566e672b1830ab9252b6b338fb73f124c422"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5dcd6e5fbfb750689ef43b9fbeada9a84155721a41e0daf4e723c03b5837a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3bea9f3c81ff41afca79d965a9f2c133f8b7389f79361225d50b8ba76ff1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84016c2220674f2502745ea79ee101389dee684b727b46f9d04996bbf19bead"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
