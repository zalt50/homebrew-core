class Bashka < Formula
  desc "Static verification of installation bash scripts"
  homepage "https://github.com/dmtrKovalenko/bashka"
  url "https://github.com/dmtrKovalenko/bashka/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "dd3150e9029164be08b55d22f828d1bf989b5b4ced25cd665478f89558ed8849"
  license "MIT"
  head "https://github.com/dmtrKovalenko/bashka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd3385694a9d5b81c39c0ac426dce5a9b5e3f04d168b38fbfe51234353bd3866"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d521924ea30b6bd01eb5c3ecdef68a4ffe93938f21b0a9f97b4bad3398a92de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28f83f91ba8ac936cfdee071c94f2410eceb6fbb3dd22586134d53f6b09f139d"
    sha256 cellar: :any,                 arm64_linux:       "d5820528afa2b27c1a12fe77ec2258075e5d0c0af07e4998d1b9b2615fe35bd1"
    sha256 cellar: :any,                 x86_64_linux:      "b1f627a2c16b527c7ded532871b29d1ad3bea46860195f0fd845ffb9f47ab7d8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bashka --version")

    malicious = <<~BASH
      #!/usr/bin/env bash

      rm -rf /
    BASH
    empty = <<~BASH
      #!/usr/bin/env bash

      echo Hi
    BASH

    # Couldn't capture `stderr` for some reason (`2>&1` and `open3` methods didn't work).
    # Don't match output, just check the exit codes
    pipe_output("#{bin}/bashka --check", malicious, 3)
    pipe_output("#{bin}/bashka --check", empty, 1)
  end
end
