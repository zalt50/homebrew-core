class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.211.0",
      revision: "0009e3be4803386453aa7be7efc6966a5eda42dc"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08a8cfeab319c9df0bf28dbced466cda167bac9764af6102f17b93d384fdb1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1de61267cd2a29797d41ca76c94990e4a047ffc3b71839efab59354ea0aa6db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d5407f2e5078570d8de11e2643ce52e99e7f1629197ed566d63e6813c95ebeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "488bb161a37381d08bac8db3f818b6c56b5146db21c32a9a70484c1927ac044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed71cdceb006d87fe55f6f34a538039967a83221cc755bbabaaa7039fe43cda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129e30919530eb15a7b79da32b386db94c997f94c835446da74aeb83f5245ecb"
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
