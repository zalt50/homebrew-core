class Bashka < Formula
  desc "Static verification of installation bash scripts"
  homepage "https://github.com/dmtrKovalenko/bashka"
  url "https://github.com/dmtrKovalenko/bashka/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "97758cacce997405acae16fe00b571d54dab1a7fabad2cc3795711be604e236d"
  license "MIT"
  head "https://github.com/dmtrKovalenko/bashka.git", branch: "main"

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
