class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "9de4636ca6a2e676a64d58ecbcb26c66b4b885b1ebbb7058950625a9f0df53fc"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e624676b2471c7b70559a5fd6b6f46dae49677660f2f95730da022f14202c64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a8984e804ae668bba156ed6ed478d290d4114d55ad8ff97cfe91c5abceeabd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a45a8210541f2ffb73d2ea0eddd8e1c8cfa7eef9da7ee2d2a57a5ab0770059"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3f74c9b83159cc20bddcb8f76ba22230fd222e4d58e25ed5fcef8793e08617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c0ee46e82b4f0127e5f66e7d9a269fbb51918297a3514ed2f323fd07572fc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0970d40470161fcb785d4f2e4b2a7c3148721e479d9c339c231416f290147b4c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane/v#{version.major}/internal/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"composition.yaml").write <<~YAML
      apiVersion: apiextensions.crossplane.io/v1
      kind: Composition
      metadata:
        name: example
      spec:
        compositeTypeRef:
          apiVersion: example.org/v1alpha1
          kind: XExample
        mode: Pipeline
        pipeline:
          - step: example
            functionRef:
              name: example-function
    YAML

    output = shell_output("#{bin}/crossplane beta convert composition-environment " \
                          "composition.yaml -o converted.yaml 2>&1")
    assert_match "No changes needed", output
  end
end
