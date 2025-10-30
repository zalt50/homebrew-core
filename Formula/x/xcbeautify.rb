class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/cpisciotta/xcbeautify"
  url "https://github.com/cpisciotta/xcbeautify/archive/refs/tags/3.0.0.tar.gz"
  sha256 "de5c61f00adb8cfd56029a113920d5420345cdac4462e8eb3324a154d4765ac6"
  license "MIT"
  head "https://github.com/cpisciotta/xcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f41771ed89a4c862b243befc8af41bae4522dd6d84f4f0688b6b7d70566c511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03457fe184970c4f780fa8bc01b00c9823a628750586a4e0b85b6f15e3f2743a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde9a0a133d0c5d4cc2feff22f107a0893c6c49cedd40ccbc50882503bf03a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b34fa006a10d84d03bcd5db42f60e7a66a23265723329c5a3bcb1fc5641418a"
  end

  # needs Swift tools version 6.1.0
  depends_on xcode: ["16.3", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    if OS.mac?
      args = %w[--disable-sandbox]
    else
      libxml2_lib = Formula["libxml2"].opt_lib
      args = %W[
        --static-swift-stdlib
        -Xlinker -L#{libxml2_lib}
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", libxml2_lib
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
