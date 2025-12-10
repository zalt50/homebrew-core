class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "11f84032ea4f2ea3a9fe85e92486a1c11dd6745052e2b57cfaaeabb8460f7823"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86ea94c86ad6f7e22de2e9477fd0018584529765320aac2d4e24ada3c45d84ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d77b43f1a4cecfb25a716a0ae7127a714238983ca4be528c837695ce47f581f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6657e3fed883e34899e3cc5f207c9626fa50e4e74a6f4c0fdab6efcdf6b9da"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab0eb48796cf332ff43b49340938900eed1eabd9efcbf15b0acc139450c8ee28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd2397a2411e6e0bf209667bcd59d241b67039515f3272226de78caed0976122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e19f66ab0e105e486d9067c2f140bac895df395fb68d36000e5e5b4ea11c1fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
