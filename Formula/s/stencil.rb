class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "de2d799a906f6c0b77373780a3dff242762a96da83469e12b1f06064563f7f46"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc271ab60b57da555abdd6e090950c7145dd5fa016938d93644f0188feea94c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217e3dbc1d9ae9799334863ba69b0a085e4971d6bb6dceda67d7dc9ee55c9da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3e1eed69421301a5e4cbd5440c1a29c0567530f8525c24e9cc32e6cf303a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "845bd4ab371b63c3e832cdbd2bfd4e4f19339306a1d333185f9ab684f9efae5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f6bc73b64bf081fe0f16338edf4ad2e238384a31bf58d3a36df4b14bb8dc5c8"
    sha256 cellar: :any,                 x86_64_linux:  "4fab4701077739ba24f28f658adc7c902a8c427c3bf97213f78e22e55df6110d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
    generate_completions_from_executable(bin/"stencil", "completion",
                                          shell_parameter_format: "",
                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
