class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-26.7.25.tgz"
  sha256 "429fc852a3792cd5abc2b5d0ce553145e4ef73721bf62e89172c85ec8dee078d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05e667871025b6f78e7af5970011b0258d5a8d93d7e7d87c7b7bc165db297025"
  end

  depends_on "openjdk"

  def install
    libexec.install "build/dist/vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    HTML
    system bin/"vnu", testpath/"index.html"
  end
end
