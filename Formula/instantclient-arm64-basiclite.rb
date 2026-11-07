# A formula that installs the Instant Client Basic Lite package.
class InstantclientArm64Basiclite < Formula
  desc "Oracle Instant Client Basic Lite for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-basiclite-macos.arm64-23.26.2.0.0.dmg"
  sha256 "54defa9e957da0aef6219965da3cb2d22ac19bfb20f168741b424c89e90d47ea"

  conflicts_with "instantclient-arm64-basic"

  def install
    lib.install Dir["*.dylib*"]
  end
end
