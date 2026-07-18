class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "34737a2956eb0c5d6db1b9e71470682a4e9ea8998486b7faafa257a5f4a5a2ba"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6a65d4e25283adf96d1a9503f2326c51cb0a4df3e4636a52609c9a57bc47e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9772a9d97e12e5dd0930ef611b3acefd4f442bb7a4f06c06efb9fe8f5c5f3ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07be71060c0766ecca237188443db099b19ea948f7de9eb41fd2a76773d4cb8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e92bd0d6eaa078802ab14eaea2f84afdacc37eeefcee5883713f6ebffdcc55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d633d0df4785e1b0189a614a0c5d5e408b352632c5230b5078e53df2e86842"
    sha256 cellar: :any,                 x86_64_linux:  "9470436dcb8686a83b446f540b9e9390a37fab699a60c9da3bb4070139671b6f"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}/aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}/aliae --version")
  end
end
