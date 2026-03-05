class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.45.1.tar.gz"
  sha256 "dc17e1e96a8e00ed4a86a3c047dd4e469d0b3e882f9a4027899bee2540838a67"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7095682afcf53e068132dff7ae6ec52676b4c7df9d363cb03cc6446784fd77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7316f6ef646a1fcf3938f37fbe90a46a21cb181ab48fa40b70d65bfa0cebc960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ff39c978043449b99a1222dde21576b7ca18798c5a30559cd0cb91c9108416"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a6481501303dd904c10d953e315bde15080d68df7a34bd7d811d69a074859b"
  end

  depends_on xcode: ["15.3", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~YAML
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    YAML
    (testpath/"TestProject").mkpath
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_path_exists testpath/"GeneratedProject.xcodeproj"
    assert_path_exists testpath/"GeneratedProject.xcodeproj/project.pbxproj"
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end
