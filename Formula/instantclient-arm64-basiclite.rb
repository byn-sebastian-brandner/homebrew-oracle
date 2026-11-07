# A formula that installs the Instant Client Basic Lite package.
class InstantclientArm64Basiclite < Formula
  desc "Oracle Instant Client Basic Lite for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-basiclite-macos.arm64-23.26.2.0.0.dmg", using: :nounzip
  sha256 "54defa9e957da0aef6219965da3cb2d22ac19bfb20f168741b424c89e90d47ea"

  depends_on "sevenzip" => :build

  conflicts_with "instantclient-arm64-basic"

  def install
    # Homebrew cannot mount DMGs inside its build sandbox (hdiutil attach fails
    # with "Device not configured"), so extract the image with 7-Zip instead.
    system Formula["sevenzip"].opt_bin/"7zz", "x", "-y", Dir["*.dmg"].first

    lib.install Dir["*.dylib*"]
  end
end
