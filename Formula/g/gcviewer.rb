class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.37.jar"
  sha256 "325a5f1a8f67588b6845c71eceb70c8b74c45930fd553ba2fc7b3b4118608e13"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gcviewer[._-]v?(\d+(?:\.\d+)+)\.jar}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a328eede0efee60ae573264f46a858ad1719edd56e787e0ce9aadeac6ed017c9"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"gcviewer-#{version}.jar", "gcviewer"
  end

  test do
    assert_path_exists libexec/"gcviewer-#{version}.jar"
  end
end
