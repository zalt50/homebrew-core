class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "01370d25fc29c7e90d827870652a54c697cb465046946b874e2d8d60a3d5ac8f"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a00b40ab10cfb89f8418ca518f8e8d43566b5d85a6c3db639dc414b2aa1a35db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa25c6b09af7d88716c7853f43dc7cf2da6544ca7c6821f12004e77586515671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a0ca1fe13ceae22f6c6be0bd7db0a321edceb7d9deb55030aaed1599c07942a"
    sha256 cellar: :any,                 arm64_linux:       "3749db8663b999b4d299fe04957bac17621dc6323deb38bb21f2f466ba319515"
    sha256 cellar: :any,                 x86_64_linux:      "097fbe3f4bd5893b4e8b3a97667c0649c31b59fe4b5dba29c2b0f4af5b2021d3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kwctl")

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwctl --version")

    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
