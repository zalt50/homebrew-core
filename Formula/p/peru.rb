class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https://github.com/buildinspace/peru"
  url "https://files.pythonhosted.org/packages/46/93/97b31e2052b4308cbc413d85b6b6b08a3beeeac81996b070723418a0c24e/peru-1.3.5.tar.gz"
  sha256 "2cc1a0d09c5d4fc28dda5c4bf87b4110ee2107e9ce7fb6a38f8d6f60a91af745"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0e6db76fb7d9e625270f674647f7ffc117be781df15b587aa4eecfb7a23677ae"
    sha256 cellar: :any,                 arm64_sequoia: "6c44172cb1bb4e9f68b248aeed7058107e48ec3b7b6920b1e4fdb8f98adbf822"
    sha256 cellar: :any,                 arm64_sonoma:  "ae877adc898be55ea289ec5996aca6f9039ac44cc3a2c484b81f23f1be763816"
    sha256 cellar: :any,                 sonoma:        "e063ed53447b77f612299323fda24cd5e34c8ff3713e3accd1e766e5d632e9ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f0fd3c6af85d2ade9e26a75f0d8b444d42a1f41952c1aac1864fa9b8dcb7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f2ea8109ac0a0061e8ecd68292e2d7858ce4e1c061a55bd8c4514e38cc39b6"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peru/resources/plugins/**/*.py"].each do |f|
      inreplace f, "#! /usr/bin/env python3", "#!#{libexec}/bin/python3.14"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath/"peru.yaml").write <<~YAML
      imports:
        peru: peru
      git module peru:
        url: https://github.com/buildinspace/peru.git
    YAML

    system bin/"peru", "sync"
    assert_path_exists testpath/".peru"
    assert_path_exists testpath/"peru"
  end
end
