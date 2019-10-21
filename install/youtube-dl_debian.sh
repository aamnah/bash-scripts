#!/bin/bash

# Taken from: https://tldrdevnotes.com/misc/youtube-dl_audio_download/

echo -e "\n Installing youtube-dl ... \n"
# install latest youtube-dl version
#sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
#sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
#sudo chmod a+rx /usr/local/bin/youtube-dl

# Ubuntu
# an older version is available in the repos. 
# You can install that and run with `--update` to get to the latest version
sudo apt install youtube-dl
youtube-dl --update

# install ffmpeg to be able to convert video files to audio
sudo apt install -y ffmpeg

# macOS
# brew install youtube-dl ffmpeg

# create conf file
echo -e "\n Creating configuration file ... \n"
sudo touch /etc/youtube-dl.conf

sudo sh -c "echo \"
# Always extract audio (-x or --extract-audio)
--extract-audio

# Always save Audio in MP3 format
--audio-format mp3

# Save all files to a specific folder
#-o /mnt/d/Music/%(title)s.%(ext)s

# Save to the Linux User's Music dircetory
-o /home/${USER}/Music/%(title)s.%(ext)s
\" >> /etc/youtube-dl.conf"

# add 'ydl' alias
echo -e "\n Adding 'ydl' alias ... \n"
if [ -f ${HOME}/.bash_aliases ]; then
    # if one exists, add the ydl alias
    echo "alias ydl='youtube-dl'" >> ${HOME}/.bash_aliases
else
    # if file doesn't exist create one, and then add the alias
    touch ${HOME}/.bash_aliases
    echo "alias ydl='youtube-dl'" >> ${HOME}/.bash_aliases
fi

# reload Bash so that the alias works right away
source ${HOME}/.bashrc 
#source ${HOME}/.bash_profile

echo -e " 
 DONE! You can now download audio from Youtube using 'youtube-dl' or the 'ydl' alias

 Examples: 

    youtube-dl https://www.youtube.com/watch?v=xvtBAXM-YZs

    ydl https://www.youtube.com/watch?v=xvtBAXM-YZs

"


# Links
# https://stackoverflow.com/questions/84882/sudo-echo-something-etc-privilegedfile-doesnt-work
