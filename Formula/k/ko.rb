class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "1006eb94b6260690ab3ec79cbd03342e09cb0f32cecdd1b8743fa216e2fe7b0e"
  license "Apache-2.0"
  head "https://github.com/ko-build/ko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbcd091cde091371c2f0156d9a208dbc49e87abd3acd42f9e7f031a68b9a8fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ebbf1f9c0117c708c6837f964c9cd66192d0d40b6bf70be489b232c2b97e90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ebbf1f9c0117c708c6837f964c9cd66192d0d40b6bf70be489b232c2b97e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51ebbf1f9c0117c708c6837f964c9cd66192d0d40b6bf70be489b232c2b97e90"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede5eb93a54e739e5d2a957ae57c26aa5ca6e58bcf4dcae69985f968ea2e8a06"
    sha256 cellar: :any_skip_relocation, ventura:       "72711771259318dce21574c99cee46c9ffcaeec187f307875e0d45327359601e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6208406d49e2ba009013f8735875a165c14a3543a793be5941aac159041f14bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab0a89bed6ceefe2fd0d40f46e086e105c43e76ea50c94f7bca1ae217a188a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
