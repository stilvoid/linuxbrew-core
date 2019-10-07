class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.0.3.tar.gz"
  sha256 "cee59c0a477c8166d722703f6e52f962028f3ac43a5f41240ecb45dbdbe2d6ae"
  revision 1
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "7c4d1bfaa974db039bdd7ec219d22206b63833b4c2a2d078db52c8f6742031ce" => :catalina
    sha256 "587beb4ccaa5e7fb85d1c4465487fb315e4ef168a30ad674c614d8c0ba84ca6b" => :mojave
    sha256 "fff29cb6a95e692fb68bda037ccef83164a91e550e784d643446f777a9cb8ccc" => :high_sierra
    sha256 "3cbd050f46aef41c733b56ab49dc081c6bd39ad67c79d3a24381a01291c8a1ad" => :sierra
    sha256 "3bfc6cd486dd41098cfcb582a98585645002ad42d466d110f2da45c5b5699228" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DSWIPL_PACKAGES_JAVA=OFF",
                      "-DSWIPL_PACKAGES_X=OFF",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      *("-DCMAKE_C_COMPILER=/usr/bin/clang" if OS.mac?),
                      *("-DCMAKE_CXX_COMPILER=/usr/bin/clang++" if OS.mac?)
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
