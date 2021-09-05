#!/bin/bash
cd "$(dirname "$0")"

#sync ~/.config/ directory
mapfile -t config_dirs < <(ls -d ./home/p1xel/config/*/)
for i in "${config_dirs[@]}"; do
	rsync -ac --delete-after ~/.config/"$(basename "$i")"/ "$i" 
done
rsync -c ~/.config/picom.conf ./home/p1xel/config/
rm -r ./home/p1xel/config/deadbeef/dspconfig ./home/p1xel/config/deadbeef/socket ./home/p1xel/config/deadbeef/playlists/

#sync /etc/ directory
cd ./etc/
mapfile -t etc_dirs < <(find . -type f | sed 's/^./\/etc/')
cd ..
for i in "${etc_dirs[@]}"; do
	rsync -c "$i" ."$i"
done

#sync ~/.local/
rsync -c ~/.local/share/applications/ranger.desktop ./home/p1xel/local/share/applications/

#sync rc files in ~/
cd ./home/p1xel/
mapfile -t rc_files < <(find . -maxdepth 1 -type f | sed 's/^..//')
cd ../../
for i in "${rc_files[@]}"; do
	rsync -c ~/."$i" ./home/p1xel/"$i"
done

#sync scripts in /usr/local/bin/
cd ./usr/local/bin/
mapfile -t usr_local_bin_files < <(find . -maxdepth 1 -type f | sed 's/^..//')
cd ../../../
for i in "${usr_local_bin_files[@]}"; do
	if [ ! -f /usr/local/bin/"$i" ]; then
		rm ./usr/local/bin/"$i"
	else 
		rsync -c /usr/local/bin/"$i" ./usr/local/bin/
	fi
done
