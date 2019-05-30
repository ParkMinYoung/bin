find | xargs -i file {} | grep "Bourne-Again shell" | awk '{print $1}' | sed 's/:$//'
