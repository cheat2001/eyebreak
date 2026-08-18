#!/bin/bash
#
# EyeBreak - Generate the Sparkle appcast feed
#
# Produces appcast.xml describing a single (latest) update. Sparkle fetches this
# feed from SUFeedURL, compares sparkle:version against the installed
# CFBundleVersion, and offers a one-click install when the feed is newer.
#
# Usage:
#   EYEBREAK_VERSION=2.4.0 \
#   SPARKLE_PRIVATE_KEY_FILE=/path/to/key \
#   ./scripts/make_appcast.sh <path-to-zip> <sign_update-binary>
#
set -euo pipefail

ZIP_PATH="${1:?usage: make_appcast.sh <zip> <sign_update>}"
SIGN_UPDATE="${2:?usage: make_appcast.sh <zip> <sign_update>}"

VERSION="${EYEBREAK_VERSION:?EYEBREAK_VERSION must be set}"
KEY_FILE="${SPARKLE_PRIVATE_KEY_FILE:?SPARKLE_PRIVATE_KEY_FILE must be set}"
REPO="${GITHUB_REPOSITORY:-cheat2001/eyebreak}"

test -f "$ZIP_PATH" || { echo "error: $ZIP_PATH not found" >&2; exit 1; }

# Sparkle orders updates by CFBundleVersion, so it must increase monotonically.
# Deriving it from the semantic version keeps that guaranteed and readable:
#   2.4.0 -> 20400,  2.10.3 -> 21003
build_number_from_version() {
    local v="${1#v}"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$v"
    major="${major:-0}"; minor="${minor:-0}"; patch="${patch:-0}"
    # strip any non-numeric suffix (e.g. "0-beta1")
    major="${major%%[^0-9]*}"; minor="${minor%%[^0-9]*}"; patch="${patch%%[^0-9]*}"
    echo $(( 10#${major:-0} * 10000 + 10#${minor:-0} * 100 + 10#${patch:-0} ))
}

BUILD_NUMBER="$(build_number_from_version "$VERSION")"
ZIP_NAME="$(basename "$ZIP_PATH")"
ZIP_SIZE="$(stat -f%z "$ZIP_PATH")"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ZIP_NAME}"
RELEASE_URL="https://github.com/${REPO}/releases/tag/v${VERSION}"
PUB_DATE="$(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S +0000')"
MIN_SYSTEM="$(/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' EyeBreak/Info.plist 2>/dev/null || echo '14.0')"

echo "Signing $ZIP_NAME ..."
SIGNATURE="$("$SIGN_UPDATE" "$ZIP_PATH" --ed-key-file "$KEY_FILE" -p)"
test -n "$SIGNATURE" || { echo "error: signing produced no signature" >&2; exit 1; }

cat > appcast.xml <<XML
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
    <channel>
        <title>EyeBreak</title>
        <link>https://github.com/${REPO}</link>
        <description>Most recent updates to EyeBreak</description>
        <language>en</language>
        <item>
            <title>Version ${VERSION}</title>
            <pubDate>${PUB_DATE}</pubDate>
            <sparkle:version>${BUILD_NUMBER}</sparkle:version>
            <sparkle:shortVersionString>${VERSION}</sparkle:shortVersionString>
            <sparkle:minimumSystemVersion>${MIN_SYSTEM}</sparkle:minimumSystemVersion>
            <description><![CDATA[
                <h2>EyeBreak ${VERSION}</h2>
                <p>See the <a href="${RELEASE_URL}">full release notes on GitHub</a>.</p>
            ]]></description>
            <enclosure url="${DOWNLOAD_URL}"
                       length="${ZIP_SIZE}"
                       type="application/octet-stream"
                       sparkle:edSignature="${SIGNATURE}" />
        </item>
    </channel>
</rss>
XML

echo "✅ appcast.xml written"
echo "   version      : ${VERSION} (build ${BUILD_NUMBER})"
echo "   enclosure    : ${DOWNLOAD_URL}"
echo "   size         : ${ZIP_SIZE} bytes"
echo "   edSignature  : ${SIGNATURE:0:32}..."
