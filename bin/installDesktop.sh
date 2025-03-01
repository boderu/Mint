#!/usr/bin/env bash

pushd $HOME

echo ; echo "Configure desktop and applications"

# gibt es eine abweichende Font-Skalierung?
if [ -f $HOME/.text-scaling-factor ]
then
	echo "eine abweichende Font-Skalierung von $(cat $HOME/.text-scaling-factor) einrichten"
	cat $HOME/Mint/org.cinnamon.dconf | \
		sed "s/text-scaling-factor=.*/text-scaling-factor=$(cat $HOME/.text-scaling-factor)/" | \
		dconf load /org/cinnamon/
else
	# nein, es gibt keine abweichende Font-Skalierung
	dconf load /org/cinnamon/ < $HOME/Mint/org.cinnamon.dconf
fi

dconf load /org/nemo/						< $HOME/Mint/org.nemo.dconf
dconf load /org/x/editor/					< $HOME/Mint/org.x.editor.dconf
dconf load /org/x/pix/						< $HOME/Mint/org.x.pix.dconf
dconf load /org/x/reader/					< $HOME/Mint/org.x.reader.dconf
dconf load /org/gnome/calculator/			< $HOME/Mint/org.gnome.calculator.dconf
dconf load /org/gnome/terminal/				< $HOME/Mint/org.gnome.terminal.dconf
dconf load /org/gnome/desktop/interface/	< $HOME/Mint/org.gnome.desktop.interface.dconf

popd

# EOF
