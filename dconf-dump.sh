#!/bin/bash
dconf dump /org/cinnamon/ > org.cinnamon.dconf
dconf dump /org/nemo/ > org.nemo.dconf
dconf dump /org/x/editor/ > org.x.editor.dconf
dconf dump /org/x/pix/ > org.x.pix.dconf
dconf dump /org/x/reader/ > org.x.reader.dconf
dconf dump /org/gnome/calculator/ > org.gnome.calculator.dconf
dconf dump /org/gnome/terminal/ > org.gnome.terminal.dconf
