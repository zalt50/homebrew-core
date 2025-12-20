class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  # Original homepage `https://blog.sbstp.ca/introducing-kubie` is down.
  homepage "https://sbstp.ca"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "60e5677c8c7efdba94cfeebff9cec3df68bd54e3c0e927ab811fa08f4d519300"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2f8538c13db6ba4e1d6dedec50d25d90ebe1fca7ee8741a2a77ee239705731d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da179f4a2f9b1fb3ebfdc096368cd0a6359b2f198b3d9bde9fa57b4e58acc5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d376e930bd25e399822d3a0139888b3b5e88cf4b9504fcc582675b39960a1a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "41168f79edca43a9198c23a1f01eb4c4ec04448902aef05ccf1693e60aee8ee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db2d43376149f20ffd56e753b391d35ed7e53eb02c73d006549a6c40953c29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac60bd66a03a1009f4768a784332f4d099ed6779760d0ef5a3ce399ba373d723"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kubie", "generate-completion")
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    YAML

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
