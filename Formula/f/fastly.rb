class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "732338087b184fc01990de61d27dbe6f64fc99e8abe07331dec87cdf5f06669e"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f48d4a4a9fa10bd94d398bc30b0bc11114f23ffab101ea5421262ea42146a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f48d4a4a9fa10bd94d398bc30b0bc11114f23ffab101ea5421262ea42146a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f48d4a4a9fa10bd94d398bc30b0bc11114f23ffab101ea5421262ea42146a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a1426d4aa89acf59c77306bfe39dc30b93a3fc5d8d32b452498f69a5f168b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b3187fd9818d2dbda69c543e47dac73ffc9468d9ba95b628bb588d45441628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1461161462a7ad8b8c4db31f32fbdf250fbd535a2ba3ae33c5f23e1fd72a4e"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
