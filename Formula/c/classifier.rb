class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "fc4ccdb302ead4758f8a2687c815250e050aa407145745150a92be474107d93f"
  license "LGPL-2.1-or-later"

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "classifier.gemspec"
    system "gem", "install", "classifier-#{version}.gem"

    bin.install libexec/"bin/classifier"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/classifier --version")

    # Test with pre-trained remote model (SMS spam detection)
    output = shell_output("#{bin}/classifier -r sms-spam-filter 'You won a free iPhone'")
    assert_match "spam", output.downcase

    output = shell_output("#{bin}/classifier -r sms-spam-filter 'Meeting at 3pm tomorrow'")
    assert_match "ham", output.downcase
  end
end
