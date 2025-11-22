class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.1.1.tar.gz"
  sha256 "662ea05a051f27c0ce4ffc7e6d815865d49f8821615438f24bde15cff9dc2acc"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268741b8c03d3a89d536c63f99d23e4f1ca3befbb12af38c6030d74e291868b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b75175e00f954d1132f3085f2794e1e3cfc36a6740e5e8ae50f5ed4a5009ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcbcca352c6158c490032f5640c024c7a9f1aa9ef2e510dd208a010c8d6203e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c176ffadcb073be254c17c7035d47c5eb3b4dd0c688f2d820dcb95ea343168c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204eab9ae3b7c24128a945a1d0c7fbe893c90a8d33fb84a8d10d7686ed6f60bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53077351efd147027757dbcb7702209f2a76a07720462cb8154c0d3052683d95"
  end

  # needs Swift tools version 6.1.0
  uses_from_macos "swift" => :build, since: :sequoia
  uses_from_macos "libxml2"

  on_sequoia do
    # Workaround for https://github.com/apple/swift-argument-parser/issues/827
    # Conditional should really be Swift >= 6.2 but not available so using
    # a check on the specific ld version included with Xcode >= 26
    depends_on xcode: :build if DevelopmentTools.ld64_version >= "1221.4"
  end

  def install
    args = if OS.mac?
      %w[--disable-sandbox]
    else
      %w[--static-swift-stdlib -Xswiftc -use-ld=ld]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xcbeautify"
    generate_completions_from_executable(bin/"xcbeautify", "--generate-completion-script")
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
