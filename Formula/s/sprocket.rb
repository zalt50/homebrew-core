class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.20.0",
      revision: "9240ac79945aec2d74593b2d080f8b01135ed2ae"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00e68e47d4e9aa3be2bbaffdeaad16e9c64b6c43735cde35055fbc7456ee62c1"
    sha256 cellar: :any,                 arm64_sequoia: "83614163870a12452ab9008e54826017191ae93e089b6707a9780697972b6d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "9c760b7e01107c68525eae0c60d555a341d651d54cea07c8d75f41188ecbf647"
    sha256 cellar: :any,                 sonoma:        "1c8d5bacee6307f0335e030aac3d6efb1878e9b425127d0110c1ccef0c227a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51945f0a21217d07b6b68d2a49e2d7eeefee97bc54ff5c0f8ef8ddf573b5807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe66ab46ad51290c3bc5c088d1ed74d905ce2cd93c9f345006784f8ad5bf5e6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sprocket --version")
    (testpath/"hello.wdl").write <<~WDL
      version 1.2

      task say_hello {
        input {
          String greeting
          String name
        }

        command <<<
          echo "~{greeting}, ~{name}!"
        >>>

        output {
          String message = read_string(stdout())
        }

        runtime {
          container: "ubuntu:latest"
        }
      }
    WDL

    expected = <<~JSON.strip
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
