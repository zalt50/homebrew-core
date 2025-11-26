class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "50af3d3722b79bc438d84a040aac9d47856a945a8f769d0255f90ba5a3f4d218"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e256f87d448e37679282db1391726728040b8d208af98bf91c8b1f988e929d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9d91949bc0607784c43171f31682c6b7bae59aab4d371fadc14f7fd562a7c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158ff636b37fb65f5ee469d9d66c0fabf411c3f588064fc9d89aa56acbce307e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd2f170fba164d9455cc8101bffd7402c2f7d5bbb16f273896677d3ae8806f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2b7ccc0709a665b4ae05b6a27fc1b550ff6c2636e470e8c29b641c1e22e442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd613f1005a52fc9a8180574039c3ffb77dfad6869e767f319e2f2f1910cb45"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
