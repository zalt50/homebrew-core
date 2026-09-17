class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "83226abe4516e4e39953dee0d341b26e4c6f5a7f2f62ea07074bd2f8dd55c664"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37bccb5d79163142f729d92a073cd65920a08659eb29da28a11b6313716b61ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0557fa96a7705b34f66a4b814d498490ef442fc042c1fd0e2e7b5028ef586804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "591a726472cf4339f33245104189a4cc230cb12470f452a6812c26799b5e2854"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0b517d1b162a1e9927757f3464c1f46bd80db31df7e7919eb194daa176d1f52"
    sha256 cellar: :any,                 x86_64_linux:      "b41c48bf21ddfa916c02ca314988ea5eb52330a62097c0eb80740f5b8dde625f"
  end

  depends_on "go" => :build

  def install
    project = "github.com/cert-manager/cmctl/v2"
    ldflags = %W[
      -X #{project}/pkg/build.name=cmctl
      -X #{project}/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cmctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~YAML
      apiVersion: cert-manager.io/v1beta1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        secretName: test
        issuerRef:
          name: test-issuer
          kind: Issuer
        commonName: example.com
    YAML

    expected_output = <<~YAML
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    YAML

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
