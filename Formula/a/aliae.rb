class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "34737a2956eb0c5d6db1b9e71470682a4e9ea8998486b7faafa257a5f4a5a2ba"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33a6c0da581d13aff0a2f4199a0470269870735cf05383d084e46a921947469f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b387f2569c6ad8dfa5008e06bf800ab8aa6b3300ba5af4a7c338ec6330832ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3282d85ed0cca8f1cba9c114b014f3ad86179294342a922c9d521663ded58930"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d44547080bebe279f7338259ad0ba9c648bb28bc7e3e9caf78507962f903f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab80a1c2526cc998c9c5c683048672a60dab712629697b4c1f22991ac72b58e"
    sha256 cellar: :any,                 x86_64_linux:  "d466bd791fddd127c804b4feef6356b4864c4a2fa197fe21866e16fcb0d562ae"
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
