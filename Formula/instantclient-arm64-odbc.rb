# A formula that installs the Instant Client ODBC package.
class InstantclientArm64Odbc < Formula
  desc "Oracle Instant Client ODBC for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-odbc-macos.arm64-23.26.2.0.0.dmg", using: :nounzip
  sha256 "377205537e3a4a7770aa385d48ba4e67b04950c57b23be8875875f77eaa2c984"

  depends_on "sevenzip" => :build

  option "with-basiclite", "Depend on instantclient-basiclite instead of instantclient-basic."

  depends_on "instantclient-arm64-basic" if build.without?("basiclite")
  depends_on "instantclient-arm64-basiclite" if build.with?("basiclite")

  def install
    # Homebrew cannot mount DMGs inside its build sandbox (hdiutil attach fails
    # with "Device not configured"), so extract the image with 7-Zip instead.
    system Formula["sevenzip"].opt_bin/"7zz", "x", "-y", Dir["*.dmg"].first

    lib.install Dir["*.dylib*"]
  end
end
