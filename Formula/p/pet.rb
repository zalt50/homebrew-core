class Pet < Formula
  desc "Simple command-line snippet manager"
  homepage "https://github.com/knqyf263/pet"
  url "https://github.com/knqyf263/pet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "b829628445b8a7039f0211fd74decee41ee5eb1c28417a4c8d8fca99de59091f"
  license "MIT"
  head "https://github.com/knqyf263/pet.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/knqyf263/pet/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pet version")
    assert_empty shell_output("#{bin}/pet list")
  end
end
