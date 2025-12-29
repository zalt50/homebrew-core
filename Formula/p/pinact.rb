class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.7.4.tar.gz"
  sha256 "1b8fb25aac4ac3cf18db639bd0c013bdfb7fa3f17f92429fc0c5df592a23f632"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b9a7e771e28140642839be15790ccd58966cc0f29bd072fd587bfc65392c54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b9a7e771e28140642839be15790ccd58966cc0f29bd072fd587bfc65392c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b9a7e771e28140642839be15790ccd58966cc0f29bd072fd587bfc65392c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f02fd8524a20488386b13a68c668c2d21b7a18344a14388cc0307544546587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1016573657ae2926a87586de943be6d0b5445027dc3d37f3c865b3c6669e035d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e254e29a3e188d8787e45a94a9c1a8f94ebbe2808201a8e4e30bf3766de68b89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
