class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "4bea0e370137d3898037f3c5c00b1d022a1735604e040ec9e22808308417ee5a"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4627b575590b11c3d572d028f19692b60f3bba5101ec872f9738bff749f37b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc2e926dc367293a866a2265ad58ee674b01afff2a5f8008ef01f29dc7e4127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf960526caa52b2f0c29a39b6da9d915c126c8ff7eff1d79f8462d825f4657e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7bfa6c533edfc4169c67808f87799d09c7348f11a162c222c274cd0b0a02d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d7ab61f1f35a05f97c0294976482254bf28cba7b8675485ad4ad55c4b3928d"
    sha256 cellar: :any,                 x86_64_linux:  "7395bf399ed6586e5ae84b8e256e5d9d905faa0573a5f132fe0ad2f14fb7913f"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=#{tap.user}
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end
