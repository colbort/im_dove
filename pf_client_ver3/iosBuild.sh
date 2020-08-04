#!/bin/sh

#flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -archivePath ~/Desktop/Runner.xcarchive -configuration release archive
xcodebuild -exportArchive -archivePath ~/Desktop/Runner.xcarchive -exportPath ~/Desktop/Runner -exportOptionsPlist ../ExportOptions.plist

