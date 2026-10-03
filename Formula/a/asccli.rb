class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "6d8b1166277f39cd0a945b4cc199460528975d31695514c3b59fb2fb27b15555"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99b7312e7b280be931760a2d2042971d8e58656edf196f34c6adf971a6d95c53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dabd9a7386608befd12fc506428ba08b34e5ee0acc51c86103fea6ef0e578dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7880023a6f053ee1b7261fd2a9b4a217ce1b497944f9ef82e09a1e506125c05"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  uses_from_macos "swift" => :build

  def install
    # Fix Swift 6.4 runtime compatibility: https://github.com/apple/swift-collections/issues/733
    inreplace "Package.resolved", <<-OLD, <<-NEW
        "revision" : "a66de878e87ef5a3d5d390e0f6d9002aa5541a43",
        "version" : "1.7.0"
    OLD
        "revision" : "98ef3c98609a1e31b7e157b5b619579001a789d6",
        "version" : "1.7.1"
    NEW
    inreplace "Sources/ASCCommand/Version.swift", 'let ascVersion = "0.1.3"', %Q(let ascVersion = "#{version}")
    system "swift", "build", *std_swift_args
    bin.install ".build/release/asc" => "asccli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asccli --version")

    # `auth check` resolves credentials from the environment and prints the
    # account status as JSON, exercising real functionality with no network
    # access. Throwaway credentials keep the test self-contained.
    ENV["ASC_KEY_ID"] = "TESTKEYID"
    ENV["ASC_ISSUER_ID"] = "00000000-0000-0000-0000-000000000000"
    ENV["ASC_PRIVATE_KEY"] = "-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----"
    status = shell_output("#{bin}/asccli auth check")
    assert_match "keyID", status
    assert_match "issuerID", status
  end
end
