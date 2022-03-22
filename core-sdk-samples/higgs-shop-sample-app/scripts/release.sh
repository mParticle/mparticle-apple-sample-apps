VERSION=$1
plutil -replace CFBundleShortVersionString -string $VERSION HiggsShopSampleApp/Info.plist
export BUILD_VERSION=$(plutil -extract CFBundleVersion xml1 -o - HiggsShopSampleApp/Info.plist | sed -n "s/.*<string>\(.*\)<\/string>.*/\1/p"); plutil -replace CFBundleVersion -string $(($BUILD_VERSION+1)) HiggsShopSampleApp/Info.plist