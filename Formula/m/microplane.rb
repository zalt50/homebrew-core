class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "437f65748272de89b8a6990f0f9fca57addf6ff6f8e4de077869976d2ce36154"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f31cd7526586a56ca273eb22776d1b3a1236520d3d450dc21efda19d56293d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d3f92ce6eb78de3a8789aeb12afe4c021c98c0c257bb46519a5a85fb725d02a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a8fd778008830116ac7046f6bcaea8e19b647d4660768e337a59359db6f12c"
    sha256 cellar: :any_skip_relocation, ventura:       "22a8fd778008830116ac7046f6bcaea8e19b647d4660768e337a59359db6f12c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cc8e17634c1fb02ed48848cd31cdd17090488eebd2decea9831fab5aacc3ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4a6e1e4dc1ab0adbeb7815c059ae06a93cad65ae9786756dc413fc74614cdb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mp", "completion")
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    system bin/"mp", "init", "-f", testpath/"repos.txt"
    # test command
    output = shell_output("#{bin}/mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
