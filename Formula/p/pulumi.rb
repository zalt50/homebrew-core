class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.249.0",
      revision: "825b24b636370373f66f398b4ddda61bf0d11efe"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3516f745f501bdc28a9f51895ed5fe4011a414a0062ffb84833e2c7a6eb959a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b7043b86cecc912bec0fa36b78347ca758d21658bf7228d71c837c8f4cedff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a782001b8e04bce7014e3eeeb507013637287487150fe4a2d4afc695e262bd4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f455c8d137b0c4b27a2d45cc0aaeac35ff5653cbdb6c97b66207ecd076e556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece874745d1096f29ee67925f1c4f60b7e2d368ab6a470345f6c313d4fa39b7e"
    sha256 cellar: :any,                 x86_64_linux:  "e728539c403ddb8f966e1dc2b0dfc7779dbdb8bbf6576f5caf8ba56cbb5b470c"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end

    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
