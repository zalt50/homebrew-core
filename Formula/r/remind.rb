class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.05.tar.gz"
  sha256 "d060f4073fa7a498824dc5a00ab567c92025a7b5121e4651663a86ea787bcdd4"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "b11a20edbcc8dacd210354145a829340ff2c751d76c639061cda230893b12b62"
    sha256 arm64_tahoe:       "c23f19a7e8bd13e02a95fe46c5f204cbe3e6801347532846922693588fa88d09"
    sha256 arm64_sequoia:     "b99e59b8231f140b7c3274405a6f14f9ecee7238a6a502c032ea2b2c2c2edb69"
    sha256 arm64_linux:       "51e2389b2e59a57d3b4592db492e87ec6e6dfff598a04b3899b8c0580566438c"
    sha256 x86_64_linux:      "e745d3f1e944eba9a639056ebf92c4d996d93212a0d32b3ac53e4caa17c55dad"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  deny_network_access!

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "-C", "src", "install"
    system "make", "-C", "rem2html", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
