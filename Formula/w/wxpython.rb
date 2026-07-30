class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/5f/59/8da2f898b3e1772ba501e5108d7d7824175485731c9b5f79381cb1e682d0/wxpython-4.3.0.tar.gz"
  sha256 "33d17964ba7392a7d08d4cdfe6573ab331fe61b3ba2e281f202fd8b4e0ef7810"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f386143a6e4461fde98aaa60c28f8dc1c87270ad53aaef1fc3b059753ca7d04b"
    sha256 cellar: :any, arm64_sequoia: "101056218733233f473e26ed0836b3c385fc55a8cb6653ab4840241df62c444e"
    sha256 cellar: :any, arm64_sonoma:  "1d8b4b5e2a4548a25fd602ceca03f1d217a508f6160b528c88cabd5da92379ac"
    sha256 cellar: :any, sonoma:        "fb2da74fde2f55b27d36418a776ed1a3a3f884319d406618d022f8e409450ba6"
    sha256               arm64_linux:   "4321aecdd3168f3f2bb0ae102d2f93da7449c0f4968f5c746f18e2e25feabf39"
    sha256               x86_64_linux:  "8b3b5bea2efe6ccac67b575e3d308d9d5688120e9da07693be91c47ff5f6f0c5"
  end

  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  # Upstream pins Doxygen 1.9.1, which keeps `constexpr` in the XML type; ours is newer
  # and reports it as an attribute, so `constexpr` members get a setter and fail to build.
  patch :DATA

  def python
    "python3.14"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python)
    ENV.cxx11
    ENV["DOXYGEN"] = formula_opt_bin("doxygen")/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/etgtools/extractors.py b/etgtools/extractors.py
index 5c3b1d4..b6e9b2d 100644
--- a/etgtools/extractors.py
+++ b/etgtools/extractors.py
@@ -222,6 +222,8 @@ class VariableDef(BaseDef):
     def extract(self, element):
         super(VariableDef, self).extract(element)
         self.type = flattenNode(element.find('type'))
+        if element.get('constexpr') == 'yes' and not self.type.startswith('const'):
+            self.type = 'const ' + self.type
         self.definition = element.find('definition').text
         self.argsString = element.find('argsstring').text
 
