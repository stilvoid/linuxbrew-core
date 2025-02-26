require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.18.0.tgz"
  sha256 "a95d67766ce8ab90a8fbdc18db1c2f6c47f85ece9a043a63445e559a2e78ff6f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "29283147431e7711c038de81747082bf220336a90be6582864f2f24f0494340f" => :catalina
    sha256 "eccb3aeced7d78bc3c3d2cd7c33fc03ab964e33001e2a6f846b1d976398122ad" => :mojave
    sha256 "fff38a4bf3d2f70e958d47fee3e0fddd3a5e2cfa43a31214c80be07331f2eade" => :high_sierra
    sha256 "e3acbb3b690f2847cb57c11d56e448bcbd878adc77ec72fed3868442c2fdeff1" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
