wget "https://packagecontrol.io/Package%20Control.sublime-package"

mv ./Package\ Control.sublime-package ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/

cp ./Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
cp ./Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
