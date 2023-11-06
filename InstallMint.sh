#!/bin/bash
# Skript um Linux Mint einzurichten. Verlinke und starte dieses Skript in und aus dem Homeverzeichnis!
# Das System sollte bereits die ersten Updates haben und die Verbindung zum Internet muss funktionieren.

function CppCheckInstall
{
	sudo make install MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes \
	CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"
}


# Funktion: erzeuge symbolische Links mit erweiterter Prüfung
# $1 Quelle:	Datei oder Verzeichnis welches verlinkt werden soll
# $2 Ziel:		der zu erzeugende symbolische Link
function Link
{
	echo
	# Exisitiert das Ziel?
	if [ -e "$2" ]
	then
		# ja, das Ziel existiert
		# ist das Ziel bereits ein symbolischer Link?
		if [ -L "$2" ]
		then
			# ja, das Ziel ist bereits ein symbolischer Link
			echo "$2 ist bereits ein symbolischer Link"

			# zeigt der symbolische Link nicht auf die Quelle?
			if [[ $(readlink "$2") != "$1" ]]
			then
				# ja, der symbolische Link zeigt nicht auf die Quelle
				echo "symbolischer Link $2 zeigt nicht auf die Quelle --> überschreiben"
				# existiert die Quelle?
				if [ -e "$1" ]
				then
					# ja, die Quelle existiert
					rm "$2"					# existierenden Link löschen
					ln -sv "$1" "$2"		# symbolischen Link erzeugen
				else
					# nein, die Quelle existiert nicht
					echo "Die Quelle existiert nicht!"
				fi
			fi
		else
			# nein, das Ziel ist kein symbolischer Link
			# existiert die Quelle?
			if [ -e "$1" ]
			then
				# ja, die Quelle existiert
				echo "$2 ist kein symbolischer Link --> existierende Datei oder Verzeichnis sichern"
				mv -fv "$2" "$2.saved"	# eine existierende Sicherung wird überschrieben
				rm -fRv "$2"			# vorhandene Datei oder Verzeichnis löschen
				ln -sv "$1" "$2"		# symbolischen Link erzeugen
			else
				# nein, die Quelle existiert nicht
				echo "Die Quelle existiert nicht!"
			fi
		fi
	else
		# nein, das Ziel existiert nicht
			# existiert die Quelle?
			if [ -e "$1" ]
			then
				# ja, die Quelle existiert
				rm -fRv "$2"			# vorhandenes Ziel löschen (evtl. fehlerhafter Link)
				ln -sv "$1" "$2"		# symbolischen Link erzeugen
			else
				# nein, die Quelle existiert nicht
				echo "Die Quelle $1 existiert nicht!"
			fi
	fi
} # Link()


cd $HOME

if [[ "$USER" != "guest" ]]
then
	echo "zusätzliche PPAs hinzufügen"
	sudo add-apt-repository -y ppa:libreoffice/ppa
	sudo add-apt-repository -y ppa:mozillateam/thunderbird-next
	sudo add-apt-repository -y ppa:ubuntuhandbook1/shotwell
	sudo add-apt-repository -y ppa:ubuntuhandbook1/darktable
	sudo add-apt-repository -y ppa:kicad/kicad-7.0-releases
	sudo add-apt-repository -y ppa:tomtomtom/yt-dlp
	sudo add-apt-repository -y ppa:longsleep/golang-backports
	sudo add-apt-repository -y ppa:aos1/diff-so-fancy
	sudo add-apt-repository -y ppa:widelands-dev/widelands


	echo
	echo "vorhandene Pakete aktualisieren"
	sudo apt update
	sudo apt upgrade -y


	echo
	echo "bereits vorhandene Pakete entfernen"
	sudo apt remove -y rhythmbox


	echo
	echo "weitere Pakete installieren"
	sudo apt install -y --install-recommends git
	sudo apt install -y --install-recommends subversion
	sudo apt install -y --install-recommends unoconv
	sudo apt install -y --install-recommends catdoc
	sudo apt install -y --install-recommends docx2txt

	sudo apt install -y --install-recommends rclone
	sudo apt install -y --install-recommends rclone-browser

	sudo apt install -y --install-recommends fonts-firacode
	sudo apt install -y --install-recommends fonts-powerline
	sudo apt install -y --install-recommends ttf-mscorefonts-installer
	sudo apt install -y --install-recommends cmatrix
	sudo apt install -y --install-recommends libreoffice-style-yaru
	sudo apt install -y --install-recommends libreoffice-style-elementary
	sudo apt install -y --install-recommends libreoffice-style-elementary
	sudo apt install -y --install-recommends libreoffice-style-sifr
	sudo apt install -y --install-recommends libreoffice-style-sukapura
	sudo apt install -y --install-recommends openclipart
	sudo apt install -y --install-recommends openclipart-libreoffice


	sudo apt install -y --install-recommends htop
	sudo apt install -y --install-recommends inxi
	sudo apt install -y --install-recommends neofetch
	sudo apt install -y --install-recommends yad
	sudo apt install -y --install-recommends sox
	sudo apt install -y --install-recommends zenity
	sudo apt install -y --install-recommends libsox-fmt-mp3
	sudo apt install -y --install-recommends mc
	sudo apt install -y --install-recommends di
	sudo apt install -y --install-recommends ncdu
	sudo apt install -y --install-recommends scdaemon
	sudo apt install -y --install-recommends micro
	sudo apt install -y --install-recommends bat
	sudo apt install -y --install-recommends stress
	sudo apt install -y --install-recommends clamav
	sudo apt install -y --install-recommends exa
	sudo apt install -y --install-recommends glmark2
	sudo apt install -y --install-recommends hardlink
	sudo apt install -y --install-recommends rmlint rmlint-doc
	sudo apt install -y --install-recommends prettyping
	sudo apt install -y --install-recommends par2
	sudo apt install -y --install-recommends nmap
	sudo apt install -y --install-recommends tree
	sudo apt install -y --install-recommends trash-cli
	sudo apt install -y --install-recommends btop
	sudo apt install -y --install-recommends tldr
	sudo apt install -y --install-recommends highlight
	sudo apt install -y --install-recommends atool
	sudo apt install -y --install-recommends caca-utils
	sudo apt install -y --install-recommends w3m
	sudo apt install -y --install-recommends poppler-utils
	sudo apt install -y --install-recommends ranger
	sudo apt install -y --install-recommends thefuck
	sudo apt install -y --install-recommends oping
	sudo apt install -y --install-recommends tmux
	sudo apt install -y --install-recommends jq
	sudo apt install -y --install-recommends progress
	sudo apt install -y --install-recommends zsh

	sudo apt install -y --install-recommends build-essential
	sudo apt install -y --install-recommends xutils-dev
	sudo apt install -y --install-recommends gcovr
	sudo apt install -y --install-recommends attr
	sudo apt install -y --install-recommends binutils-arm-none-eabi gcc-arm-none-eabi gcc-arm-none-eabi-source
	sudo apt install -y --install-recommends doxygen doxygen-doc doxygen-latex
	sudo apt install -y --install-recommends graphviz graphviz-doc
	sudo apt install -y --install-recommends ruby ri ruby-roo bundler ruby-dev
	sudo apt install -y --install-recommends asciidoctor asciidoctor-doc
	sudo apt install -y --install-recommends gnuplot
	sudo apt install -y --install-recommends wxmaxima
	sudo apt install -y --install-recommends xmlcopyeditor

	sudo apt install -y --install-recommends python3-gpg python3-pip python3-brotli
	sudo apt install -y --install-recommends default-jre
	sudo apt install -y --install-recommends libreadline-dev libpcre3-dev
	sudo apt install -y --install-recommends yt-dlp rtmpdump ffmpeg ffmpegthumbs aria2
	sudo apt install -y --install-recommends golang-go
	sudo apt install -y --install-recommends diff-so-fancy
	sudo apt install -y --install-recommends rustc cargo

	sudo apt install -y --install-recommends kicad
	sudo apt install -y --install-recommends brasero
	sudo apt install -y --install-recommends xtrkcad
	sudo apt install -y --install-recommends sweep
	sudo apt install -y --install-recommends gpick
	sudo apt install -y --install-recommends shotwell
	sudo apt install -y --install-recommends darktable
	sudo apt install -y --install-recommends evolution
	sudo apt install -y --install-recommends gparted
	sudo apt install -y --install-recommends libreoffice-script-provider-python
	sudo apt install -y --install-recommends nemo-seahorse
	sudo apt install -y --install-recommends nemo-gtkhash
	sudo apt install -y --install-recommends nemo-terminal
	sudo apt install -y --install-recommends nemo-image-converter
	sudo apt install -y --install-recommends nemo-compare
	sudo apt install -y --install-recommends nemo-filename-repairer
	sudo apt install -y --install-recommends nemo-audio-tab
	sudo apt install -y --install-recommends pan
	sudo apt install -y --install-recommends gnupg2
	sudo apt install -y --install-recommends fraqtive
	sudo apt install -y --install-recommends unison
	sudo apt install -y --install-recommends unison-gtk
	sudo apt install -y --install-recommends solaar-gnome3
#	sudo apt install -y --install-recommends kdeconnect

	sudo apt install -y --install-recommends widelands

	sudo apt install -y --install-recommends wine
	sudo apt install -y --install-recommends virtualbox
	sudo apt install -y --install-recommends firefox-locale-de

	echo
	echo "zusätzliche Rust (Cargo) Pakete"
	sudo cargo install du-dust


	echo
	echo "zusätzliche Ruby Pakete"
	sudo gem install asciidoctor-diagram
	sudo gem install roo

	echo
	echo "zusätzliche Python Pakete"
	sudo apt install -y --install-recommends libgtk-3-dev
	sudo apt install -y --install-recommends libgstreamer-gl1.0-0
	sudo apt install -y --install-recommends freeglut3
	sudo apt install -y --install-recommends freeglut3-dev
	sudo apt install -y --install-recommends python3-gst-1.0
	sudo apt install -y --install-recommends libglib2.0-dev
	sudo apt install -y --install-recommends ubuntu-restricted-extras
	sudo apt install -y --install-recommends libgstreamer-plugins-base1.0-dev
	sudo apt install -y --install-recommends wxglade
	sudo apt install -y --install-recommends python3-pip
	sudo apt install -y --install-recommends python3-tk
	sudo apt install -y --install-recommends python3-setuptools
	sudo apt install -y --install-recommends python3-dev

	echo
	echo "Flatpaks installieren"
	sudo flatpak install -y --noninteractive com.github.tchx84.Flatseal
	sudo flatpak install -y --noninteractive io.github.flattool.Warehouse
	sudo flatpak install -y --noninteractive io.github.giantpinkrobots.flatsweep
	sudo flatpak install -y --noninteractive net.displaycal.DisplayCAL
#	sudo flatpak install -y --noninteractive org.winehq.Wine
	sudo flatpak install -y --noninteractive ca.desrt.dconf-editor

	sudo flatpak install -y --noninteractive org.stellarium.Stellarium
	sudo flatpak install -y --noninteractive org.gnome.Maps

	sudo flatpak install -y --noninteractive com.bitwarden.desktop
	sudo flatpak install -y --noninteractive net.cozic.joplin_desktop
	sudo flatpak install -y --noninteractive com.nextcloud.desktopclient.nextcloud
	sudo flatpak install -y --noninteractive com.synology.SynologyDrive
	sudo flatpak install -y --noninteractive org.signal.Signal
	sudo flatpak install -y --noninteractive us.zoom.Zoom
	sudo flatpak install -y --noninteractive com.skype.Client

	sudo flatpak install -y --noninteractive com.visualstudio.code
	sudo flatpak install -y --noninteractive com.jetbrains.PyCharm-Community
	sudo flatpak install -y --noninteractive com.jgraph.drawio.desktop
	sudo flatpak install -y --noninteractive org.scilab.Scilab
	sudo flatpak install -y --noninteractive org.octave.Octave
	sudo flatpak install -y --noninteractive org.gaphor.Gaphor
	sudo flatpak install -y --noninteractive org.wireshark.Wireshark
	sudo flatpak install -y --noninteractive com.github.marktext.marktext
	sudo flatpak install -y --noninteractive com.github.afrantzis.Bless
	sudo flatpak install -y --noninteractive org.wxhexeditor.wxHexEditor
	sudo flatpak install -y --noninteractive org.sqlitebrowser.sqlitebrowser
	sudo flatpak install -y --noninteractive org.gnome.meld
	sudo flatpak install -y --noninteractive cc.arduino.arduinoide
	sudo flatpak install -y --noninteractive com.github.fabiocolacio.marker
	sudo flatpak install -y --noninteractive org.kde.labplot2

	sudo flatpak install -y --noninteractive com.prusa3d.PrusaSlicer
	sudo flatpak install -y --noninteractive org.freecadweb.FreeCAD

	sudo flatpak install -y --noninteractive org.freefilesync.FreeFileSync
	sudo flatpak install -y --noninteractive com.github.qarmin.czkawka
#	sudo flatpak install -y --noninteractive com.hamrick.VueScan
#	sudo flatpak install -y --noninteractive org.mozilla.Thunderbird
#	sudo flatpak install -y --noninteractive eu.betterbird.Betterbird
#	sudo flatpak install -y --noninteractive com.ulduzsoft.Birdtray
#	sudo flatpak install -y --noninteractive org.gnome.Evolution
	sudo flatpak install -y --noninteractive org.gnome.Contacts
	sudo flatpak install -y --noninteractive org.gnucash.GnuCash
	sudo flatpak install -y --noninteractive com.calibre_ebook.calibre
	sudo flatpak install -y --noninteractive com.github.jeromerobert.pdfarranger
	sudo flatpak install -y --noninteractive com.github.junrrein.PDFSlicer
	sudo flatpak install -y --noninteractive org.gramps_project.Gramps
	sudo flatpak install -y --noninteractive net.scribus.Scribus
	sudo flatpak install -y --noninteractive org.filezillaproject.Filezilla
	sudo flatpak install -y --noninteractive org.gnome.moserial
	sudo flatpak install -y --noninteractive io.dbeaver.DBeaverCommunity
	sudo flatpak install -y --noninteractive org.raspberrypi.rpi-imager

	sudo flatpak install -y --noninteractive org.gimp.GIMP
	sudo flatpak install -y --noninteractive net.sourceforge.Hugin
	sudo flatpak install -y --noninteractive org.inkscape.Inkscape
	sudo flatpak install -y --noninteractive com.rawtherapee.RawTherapee
	sudo flatpak install -y --noninteractive org.darktable.Darktable
	sudo flatpak install -y --noninteractive org.blender.Blender
	sudo flatpak install -y --noninteractive org.blender.Blender.Codecs
	sudo flatpak install -y --noninteractive org.gnome.eog
	sudo flatpak install -y --noninteractive com.interversehq.qView
	sudo flatpak install -y --noninteractive com.github.buddhi1980.mandelbulber2
	sudo flatpak install -y --noninteractive com.github.tenderowl.frog

	sudo flatpak install -y --noninteractive com.makemkv.MakeMKV
	sudo flatpak install -y --noninteractive com.obsproject.Studio
	sudo flatpak install -y --noninteractive fr.handbrake.ghb
	sudo flatpak install -y --noninteractive org.shotcut.Shotcut
	sudo flatpak install -y --noninteractive tv.plex.PlexDesktop
	sudo flatpak install -y --noninteractive io.mpv.Mpv
	sudo flatpak install -y --noninteractive org.gnome.Totem
	sudo flatpak install -y --noninteractive org.videolan.VLC
	sudo flatpak install -y --noninteractive org.gnome.Cheese
	sudo flatpak install -y --noninteractive com.ozmartians.VidCutter
	sudo flatpak install -y --noninteractive net.mediaarea.MediaInfo
	sudo flatpak install -y --noninteractive io.freetubeapp.FreeTube
	sudo flatpak install -y --noninteractive org.gnome.World.PikaBackup

	sudo flatpak install -y --noninteractive com.spotify.Client
	sudo flatpak install -y --noninteractive de.haeckerfelix.Shortwave
	sudo flatpak install -y --noninteractive org.audacityteam.Audacity
	sudo flatpak install -y --noninteractive org.audacityteam.Audacity.Codecs
	sudo flatpak install -y --noninteractive org.clementine_player.Clementine
	sudo flatpak install -y --noninteractive org.gnome.Rhythmbox3
	sudo flatpak install -y --noninteractive org.gnome.SoundJuicer
	sudo flatpak install -y --noninteractive org.gnome.EasyTAG
	sudo flatpak install -y --noninteractive org.ardour.Ardour

	sudo flatpak install -y --noninteractive org.gnome.Mahjongg
	sudo flatpak install -y --noninteractive net.sourceforge.lgames.LBreakoutHD
	sudo flatpak install -y --noninteractive org.frozen_bubble.frozen-bubble
	sudo flatpak install -y --noninteractive org.gnome.Aisleriot
	sudo flatpak install -y --noninteractive org.gnome.Klotski
	sudo flatpak install -y --noninteractive org.gnome.Mahjongg
	sudo flatpak install -y --noninteractive org.gnome.Mines
	sudo flatpak install -y --noninteractive org.sauerbraten.Sauerbraten
	sudo flatpak install -y --noninteractive org.seul.pingus
	sudo flatpak install -y --noninteractive org.hedgewars.Hedgewars
	sudo flatpak install -y --noninteractive org.gnome.Sudoku


	echo
	echo "Install LazyGit"
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	sudo rm -f lazygit.tar.gz
	sudo rm -f lazygit


	echo
	echo "xplr Dateimanager"
#	git clone https://github.com/sayanarijit/xplr.git
#	cd xplr
#	cargo build --locked --release --bin xplr
#	sudo cp target/release/xplr /usr/local/bin/
#	cd ..
#	sudo rm -Rf xplr

	PLATFORM="linux"  # or "macos" / "linux-musl"
	wget https://github.com/sayanarijit/xplr/releases/latest/download/xplr-${PLATFORM}.tar.gz
	tar xzvf xplr-${PLATFORM}.tar.gz
	sudo mv --force xplr /usr/local/bin/
	rm --force xplr-${PLATFORM}.tar.gz


	echo
	echo "CppCheck aktualisieren"
	sudo apt-get install -y libpcre3-dev
	git clone https://github.com/danmar/cppcheck.git
	cd cppcheck

	# gibt es eine Versionsinformation von einer vorhergehenden Installation?
	if [ -f "$HOME/.cppcheck_version" ]
	then
		# ja, CppCheck wurde schon einmal installiert
		# hat sich die Version des Repository geändert?
		if [[ $(cat "$HOME/.cppcheck_version") != $(git log --pretty="%H" -n 1) ]]
		then
			# ja, die Versionen sind unterschiedlich --> aktuelle Version merken und CppCheck installieren
			echo "neue CppCheck-Version vorhanden --> Update"
			git log --pretty="%H" -n 1 > "$HOME/.cppcheck_version"
			CppCheckInstall
		else
			echo "CppCheck-Versionen identisch --> keine Installation"
		fi
	else
		# nein, CppCheck wurde noch nicht installiert
		echo "installierte CppCheck-Version nicht vorhanden --> neue Installation"
		git log --pretty="%H" -n 1 > "$HOME/.cppcheck_version"
		CppCheckInstall
	fi
	cd ..
	sudo rm -Rf cppcheck
	echo "CppCeck Version: $(cppcheck --version)"


	echo
	echo "zusätzliche Pakete für TI Code Composer Studio 12"
	sudo apt install -y --install-recommends libc6-i386 libusb-0.1-4 libgconf-2-4 libncurses5 libpython2.7 libtinfo5


	#echo
	#echo "Install Easy Diffusion"


	#echo
	#echo "Install Automatic 1111"
	#sudo apt install -y --install-recommends wget git python3 python3-venv
	#wget https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
	#rm .fv webui.sh
	#chmod +x webui.sh
	#./webui.sh
	#rm .fv webui.sh


	echo
	echo "nicht mehr benötigte Pakete entfernen"
	sudo apt autoremove -y


	echo
	echo "User Guest einrichten"
	egrep -i guest /etc/passwd >/dev/null
	if [ $? -ne 0 ]
	then
		sudo adduser --disabled-password --gecos "Guest" guest
		sudo adduser guest users
		sudo passwd -d guest
	fi

	echo
	echo "User zur Gruppe users hinzufügen"
	sudo adduser $USER users

	echo
	echo "Gemeinsamen Ordner für alle Nutzer zum Teilen von Dateien konfigurieren"
	if [ -d /home/Share ]
	then
		echo "Ordner Share existiert bereits"
	else
		sudo mkdir /home/Share
		sudo chown root:users /home/Share
		sudo chmod ugo+rwX /home/Share
		sudo chmod g+s /home/Share
	fi

	sudo rm -f /home/Share/InstallMint.sh
	sudo cp ./InstallMint.sh /home/Share/

	echo
	echo "Öffentlichen (RO) Ordner für alle Nutzer konfigurieren"
	if [ -d /home/Public ]
	then
		echo "Ordner Public existiert bereits"
	else
		sudo mkdir /home/Public
		sudo chown $USER:users /home/Public
		sudo chmod ugo+rX /home/Public
		sudo chmod u+w /home/Public
		sudo chmod ug+s /home/Public
	fi
fi # if $USER != guest


echo
echo "zusätzliche Python Bibliotheken"
pip install GitPython
pip install pypubsub
pip install pyinstaller
pip install pypubsub
pip install subpub
pip install sqlalchemy
pip install ObjectListView
pip install lxml
pip install python-can
pip install canopen
pip install python-pptx
pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-22.04 wxPython
#pip3 install -v --user wxPython

echo
echo "lokale Konfigurationen einrichten"
if [ -d "Mint" ]
then
	cd Mint
	git fetch --all
	git pull
	cd ..
else
	git clone https://github.com/boderu/Mint.git
fi

if [ -d ".oh-my-zsh" ]
then
	cd .oh-my-zsh
	git fetch --all
	git pull
	cd ..
else
	git clone https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh
fi

echo "FireFox Download Helper App."
if [ -f "$HOME/SynologyDrive/Mint/Apps/DownloadHelper/net.downloadhelper.coapp-1.6.3-1_amd64.deb" ]
then
	sudo apt install -y $HOME/SynologyDrive/Mint/Apps/DownloadHelper/net.downloadhelper.coapp-1.6.3-1_amd64.deb
fi

echo "VueScan"
if [ -f "$HOME/SynologyDrive/Mint/Apps/VueScan/vue*.deb" ]
then
	sudo apt install -y $HOME/SynologyDrive/Mint/Apps/VueScan/vue*.deb
fi


mkdir -pv "$HOME/.config"
mkdir -pv "$HOME/.local/share"
mkdir -pv "$HOME/.local/bin"
mkdir -pv "$HOME/Media/Stable Diffusion"
mkdir -pv "$HOME/Warpinator"
mkdir -pv "$HOME/dwhelper"


Link "$HOME/Mint/.bashrc"									"$HOME/.bashrc"
Link "$HOME/Mint/.bash_logout"								"$HOME/.bash_logout"
Link "$HOME/Mint/.bash_aliases"								"$HOME/.bash_aliases"
Link "$HOME/Mint/.profile"									"$HOME/.profile"
Link "$HOME/Mint/.zshrc"									"$HOME/.zshrc"
Link "$HOME/Mint/.selected_editor"							"$HOME/.selected_editor"
Link "$HOME/Mint/bin"										"$HOME/bin"
Link "$HOME/Mint/.ne"										"$HOME/.ne"
Link "$HOME/Mint/.config/broot"								"$HOME/.config/broot"
Link "$HOME/Mint/.config/btop"								"$HOME/.config/btop"
Link "$HOME/Mint/.config/darktable"							"$HOME/.config/darktable"
Link "$HOME/Mint/.config/htop"								"$HOME/.config/htop"
Link "$HOME/Mint/.config/lazygit"							"$HOME/.config/lazygit"
Link "$HOME/Mint/.config/micro"								"$HOME/.config/micro"
Link "$HOME/Mint/.config/vlc"								"$HOME/.config/vlc"
Link "$HOME/Mint/.local/share/nemo"							"$HOME/.local/share/nemo"
Link "$HOME/Mint/.local/share/broot"						"$HOME/.local/share/broot"
Link "$HOME/Mint/.vuescan"									"$HOME/.vuescan"
Link "$HOME/Mint/Templates"									"$HOME/Vorlagen"

Link "$HOME/SynologyDrive/Mint/.vuescanrc"					"$HOME/.vuescanrc"
Link "$HOME/SynologyDrive/Mint/.ssh"						"$HOME/.ssh"
Link "$HOME/SynologyDrive/Mint/.gitconfig"					"$HOME/.gitconfig"
Link "$HOME/SynologyDrive/Mint/.git-credentials"			"$HOME/.git-credentials"
Link "$HOME/SynologyDrive/Mint/.local/share/kicad"			"$HOME/.local/share/kicad"
Link "$HOME/SynologyDrive/Mint/.local/share/rhythmbox"		"$HOME/.local/share/rhythmbox"
Link "$HOME/SynologyDrive/Mint/.local/share/strawberry"		"$HOME/.local/share/strawberry"
Link "$HOME/SynologyDrive/Mint/.local/share/gnome-mines"	"$HOME/.local/share/gnome-mines"
Link "$HOME/SynologyDrive/Mint/.local/share/widelands"		"$HOME/.local/share/widelands"

Link 	"$HOME/SynologyDrive/Mint/.local/bin/avr8-gnu-toolchain-linux_x86_64"	\
		"$HOME/.local/bin/avr8-gnu-toolchain-linux_x86_64"
#Link "$HOME/SynologyDrive/Mint/.config/darktable"			"$HOME/.config/darktable"

Link "$HOME/SynologyDrive/Bilder"							"$HOME/Bilder"
Link "$HOME/SynologyDrive/Dokumente"						"$HOME/Dokumente"
Link "$HOME/SynologyDrive/Downloads"						"$HOME/Downloads"
Link "$HOME/SynologyDrive/Calibre-Bibliothek"				"$HOME/Calibre-Bibliothek"
Link "$HOME/SynologyDrive/Musik"							"$HOME/Musik"


echo
echo "zusätzliche Mint Applets installieren:"
pushd "$HOME/.local/share/cinnamon/applets/"
if [ ! -d "weather@mockturtl" ]
then
	echo "weather@mockturtl"
	wget https://cinnamon-spices.linuxmint.com/files/applets/weather@mockturtl.zip && \
	unzip weather@mockturtl.zip
	rm -f weather@mockturtl.zip
else
	echo "weather@mockturtl already exists"
fi

if [ ! -d "cinnamon-timer@jake1164" ]
then
	echo "cinnamon-timer@jake1164"
	wget https://cinnamon-spices.linuxmint.com/files/applets/cinnamon-timer@jake1164.zip && \
	unzip cinnamon-timer@jake1164.zip
	rm -f cinnamon-timer@jake1164.zip
else
	echo "cinnamon-timer@jake1164 already exists"
fi

if [ ! -d "turn-off-monitor@zablotski" ]
then
	echo "turn-off-monitor@zablotski"
	wget https://cinnamon-spices.linuxmint.com/files/applets/turn-off-monitor@zablotski.zip && \
	unzip turn-off-monitor@zablotski.zip
	rm -f turn-off-monitor@zablotski.zip
else
	echo "turn-off-monitor@zablotski already exists"
fi
popd


# Apps und Desktop konfigurieren
dconf load /org/cinnamon/			< $HOME/Mint/org.cinnamon.dconf
dconf load /org/nemo/				< $HOME/Mint/org.nemo.dconf
dconf load /org/x/editor/			< $HOME/Mint/org.x.editor.dconf
dconf load /org/x/pix/				< $HOME/Mint/org.x.pix.dconf
dconf load /org/x/reader/			< $HOME/Mint/org.x.reader.dconf
dconf load /org/gnome/calculator/	< $HOME/Mint/org.gnome.calculator.dconf
dconf load /org/gnome/terminal/		< $HOME/Mint/org.gnome.terminal.dconf

echo
echo "broot installieren"
#sudo apt install build-essential libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev -y
#git clone https://github.com/Canop/broot.git
#cd broot
#cargo install --locked --features clipboard --path .
#cd ..
#rm -Rf broot
curl -o broot -L https://dystroy.org/broot/download/x86_64-linux/broot
sudo mv -f broot /usr/local/bin
sudo chmod +x /usr/local/bin/broot


echo
echo "kopiere Mozilla Einstellungen:"
if [ ! -d "$HOME/.mozilla" ]
then
	if [ -d "$HOME/SynologyDrive/Mint/.mozilla" ]
	then
		cp -frv "$HOME/SynologyDrive/Mint/.mozilla" "$HOME/"
	fi
fi

echo
echo "zusätzliche Firefox Einstellungen:"
echo "1) Erzeuge alle Firefox-Profile (about:profiles)"
echo "2) Synchronisiere alle Profile (verschiedene Logins notwendig)"
echo "3) Nach der Synchronisierung: don't allow Firefox to send data"
echo "4) Ändere die Toolbar, ..."
echo "5) Ändere die internen Firefox-Einstellungen (about:config)"
echo "   browser.uidensity --> 1"
echo "   signon.includeOtherSubdomainsInLookup --> false"
#read -p "drücke Enter ..."

echo
echo "Einrichtung beendet."
echo

# EOF
