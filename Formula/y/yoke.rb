class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.1",
      revision: "e010ca87464a433f7c337ce5c8e4efde915a4bd0"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1bbbd5fde7b096109d892c4633c3c383a83051eace5b6eb68a5168832ec5179"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b478de1e948b3f33a54e4cfa3a2de6c45721b8c0472248c8a7e85febcac9be38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ebcbc874e1de35fa200de880b4a68d557b00acd22d3f42e0954d199cbd7470a"
    sha256 cellar: :any_skip_relocation, sonoma:        "916d5ab7d5c3a32e201f5cddae0cacc017c72043c1312af23836efb691ba5641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e931f1d6b25bff6ddedfd8606070a766c134b48a82f058045d5748e64040b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984071c37c47953181523a63273eaa3cb389346bc0cfcc262d9a3ba5dc77c8c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
