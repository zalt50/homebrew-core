class VapoursynthVszip < Formula
  desc "VapourSynth Zig Image Process"
  homepage "https://github.com/dnjulek/vapoursynth-zip"
  url "https://files.pythonhosted.org/packages/3e/5e/3823f1c3ce492c3f0acca288501e67cbd1de4be317c436c71d5fdfdd81c9/vapoursynth_vszip-22.1.0.tar.gz"
  sha256 "93c1aaf5867ad43e1f21b77418fa89b0b1ed2191d0c4bfb03a65c958826ed8c9"
  license "MIT"

  depends_on "zig" => :build
  depends_on "python@3.14"
  depends_on "vapoursynth"

  preserve_rpath # skip unnecessary relocation for plugin which avoids headerpad errors

  deny_network_access! [:postinstall, :test]

  def python3 = "python3.14"

  def install
    plugindir = "#{Language::Python.site_packages(python3)}/vapoursynth/plugins"
    system "zig", "build", "--prefix-lib-dir", plugindir, *std_zig_args
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.vszip.ImageRead("#{test_fixtures("test.png")}"))
    PYTHON
    assert_match "Width: 8", shell_output("#{python3} test.py")
  end
end
