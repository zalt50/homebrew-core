class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.0.4",
      revision: "3247a5aae3791c8306f5b2e215c314267c31c570"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d823a0b7e77300bcc205461ed392837fcdb7f92ba2d6b22ae1a37bbbbde8629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d857d908db4fa9298468877fe636f27386c126f5c7a31051b242197865a02cf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c9e760a3d82c1ed4ad13cf31d821c9622bb2f8fc2395729c7282f4d89cfd6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa74d134d9514b1e50c7c1bfc17f7c6ca505f0b1c4d7a9229beb7fe39943a48b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3852215c26c01ab6e792d4e6529858d0a96919535d421301c7e1db2e245ea776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f757e5aa47acdf81250205068971777dd7c95144fbd88ef0943af64b1bba94d2"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
