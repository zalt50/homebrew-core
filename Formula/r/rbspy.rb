class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "b63aa137c8ce4124fff080d4f42a05d61601e207147f9db9ef66519ff2081b8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd901f25c9e4a8b463d230247e218cfab993096eda643eb432bf99e10482d699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aa3c4d964b3e1f22cb563aa9c24751c9524455abea6760f226da3c9712242cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9943023f3e840ff7448f6740f61d5e0297549406904e46df943eb3438de1ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1270038a3b198564a9a62302575c667507a4cc97eecdbae61f8bbc7705bb5d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d18b4f9e08a235e232a2364c8c87a1b2a8f26046a6a24d1ea357a51f9bde22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5157a650aa0389931188d99a1b0acc8ee70789d5a5db30e7da8d5044b12c89dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICDJNbmAAA3JlcG9ydAC9ks1OwzAQhO88RbUnkKzGqfPTRIi34FRV1to11MKxLdtphaq8O
      w5QVEEPnHrd2ZlPu5ogon+nq7sTRBy8UTxgUtCXlBIIs8YPKkTtLPRAl9WSAYGYMCSe9JAXs0
      /JyKO2UnHlndxnc1O2bcfWrCJg0bpfct2UrOsopdOUsSmgzDmbU16dAyEapfxiIxcvo5Upk7c
      ZGZTBpA+Ke0w5Au5H+2bd0T5kDUV0ZkxnzY7GEDDaKuugpxP5SUbEK1Hfd/vgXgMOyyD+RkLx
      HPMXChHUsfj8SnHNdWayC6YQ4ibM9oIppbwJsywvoI8Davt0Gy6btgS83uWzq1XTEkj7oHDH5
      0lVreuqrlmTC/yPitZXK1rSlrbNV0U/ACePNHUiAwAA
    EOS

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
    system bin/"rbspy", "report", "-f", "summary", "-i", "recording.gz",
                        "-o", "result"

    expected_result = <<~EOS
      % self  % total  name
      100.00   100.00  sleep [c function] - (unknown):0
        0.00   100.00  ccc - sample_program.rb:11
        0.00   100.00  bbb - sample_program.rb:7
        0.00   100.00  aaa - sample_program.rb:3
        0.00   100.00  <main> - sample_program.rb:13
    EOS
    assert_equal File.read("result"), expected_result
  end
end
