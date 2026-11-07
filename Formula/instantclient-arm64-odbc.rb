# A formula that installs the Instant Client ODBC package.
class InstantclientArm64Odbc < Formula
  desc "Oracle Instant Client ODBC for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-odbc-macos.arm64-23.26.2.0.0.dmg"
  sha256 "377205537e3a4a7770aa385d48ba4e67b04950c57b23be8875875f77eaa2c984"

  option "with-basiclite", "Depend on instantclient-basiclite instead of instantclient-basic."

  depends_on "instantclient-arm64-basic" if build.without?("basiclite")
  depends_on "instantclient-arm64-basiclite" if build.with?("basiclite")

  def install
    lib.install Dir["*.dylib*"]
  end
end
