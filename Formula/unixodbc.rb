class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.7.tar.gz"
  sha256 "45f169ba1f454a72b8fcbb82abd832630a3bf93baa84731cf2949f449e1e3e77"

  bottle do
    sha256 "6f16f12d3463655c3b3fc8251083f77a31b0a690ecf6ac88f4b0daea2f060044" => :high_sierra
    sha256 "4cf86c20705681ed7978e0a390d84df26264d1c41b21899e034da47c8e1803ad" => :sierra
    sha256 "85be7365deb1229df2f46ccaa71ed1a5f6083135649e42a4b345ce9e55db4140" => :el_capitan
    sha256 "6b267ff300441ca5e2c97ff64ed7aca93426e3e4746a214f82864a54e955e175" => :x86_64_linux
  end

  depends_on "libtool"

  keg_only "shadows system iODBC header files" if OS.mac? && MacOS.version < :mavericks

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  depends_on "libtool" unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
