class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48254",
      revision: "76ed0cc1b4dac024b9dec010342141764e16ff4a"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93a5282e5bd83cd42103e04992e4bbc605eecdce55e7e76fa9120d6ecb8d3dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27f97bb38550e8442741407d9d7c3eb25276e44a74de9c0f6a8f8186606ebc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de183bb70b7fb623bf6d5a16021e94dcbccae674ba7fb656ef52cd4a27b6192"
    sha256 cellar: :any_skip_relocation, sonoma:        "aac0f3653ccf705f325aaeb92a2e427b248d17991df1783fb9bfaaf78dc9893e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f609efd05e0b3e117873a867086092f64fc75d81b95011d9409412a95db112b0"
    sha256 cellar: :any,                 x86_64_linux:  "bc94a51c6c857af33fa555ec98047df357877d497c93c99715c32cf1807ddce8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
