#!/usr/bin/env bash

pushd $HOME

echo ; echo "Configure desktop and applications"

# gibt es eine abweichende Font-Skalierung?
if [ -f $HOME/.text-scaling-factor ]
then
	echo "eine abweichende Font-Skalierung von $(cat $HOME/.text-scaling-factor) einrichten"
	cat $HOME/.mint/org.cinnamon.dconf | \
		sed "s/text-scaling-factor=.*/text-scaling-factor=$(cat $HOME/.text-scaling-factor)/" | \
		dconf load /org/cinnamon/
else
	# nein, es gibt keine abweichende Font-Skalierung
	dconf load /org/cinnamon/ < $HOME/.mint/org.cinnamon.dconf
fi

dconf load /org/nemo/						< $HOME/.mint/org.nemo.dconf
dconf load /org/x/editor/					< $HOME/.mint/org.x.editor.dconf
dconf load /org/x/pix/						< $HOME/.mint/org.x.pix.dconf
dconf load /org/x/reader/					< $HOME/.mint/org.x.reader.dconf
dconf load /org/gnome/calculator/			< $HOME/.mint/org.gnome.calculator.dconf
dconf load /org/gnome/terminal/				< $HOME/.mint/org.gnome.terminal.dconf
dconf load /org/gnome/desktop/interface/	< $HOME/.mint/org.gnome.desktop.interface.dconf

popd

# EOF
