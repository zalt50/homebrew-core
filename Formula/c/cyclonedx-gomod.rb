class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod.git",
      tag:      "v1.10.0",
      revision: "ba940a6cad4202a4a6d2f9aeef33463c0011ff5f"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd7b3ce89ec8361b5c32558c62582a62f21f3574fcfd4d7f39ddfeffaa89ceef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7b3ce89ec8361b5c32558c62582a62f21f3574fcfd4d7f39ddfeffaa89ceef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7b3ce89ec8361b5c32558c62582a62f21f3574fcfd4d7f39ddfeffaa89ceef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c59b92233c8beba9f3a9ac8f3ee90d86239eef28e3db002f0c30566d57787c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d20cbef64f5f8167a18d0edd98d5f9780df07032683c1ddf0c6882791f1c367b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0264d8f7838c67048cfebe524bad1caf684ccde316a8140300d15c01d41d696d"
  end

  depends_on "go" => [:build, :test]

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyclonedx-gomod"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cyclonedx-gomod version")

    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.21
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing cyclonedx-gomod")
      }
    GO

    output = shell_output("#{bin}/cyclonedx-gomod mod 2>&1")
    assert_match "failed to determine version of main module", output
    assert_match " <name>github.com/Homebrew/brew-test</name>", output
  end
end
