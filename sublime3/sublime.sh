wget "https://packagecontrol.io/Package%20Control.sublime-package"

mv ./Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/

cp ./Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/
cp ./Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/
cp ./Side\ Bar.sublime-menu ~/Library/Application\ Support/Sublime\ Text/Packages/User/

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
