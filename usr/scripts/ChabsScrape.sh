#!/bin/bash
# SCRIPT: ChabsScrape
#
# Scrapes multiple public websites for film and TV image resource links.
# Parse and rewrite image URLS to files as Cloudinary links for Chabs Skins Top Picks.
# to query and download random images for Chabs skins top picks screen.
#
# Script may be called with no args to download all, or with one or more
# filenames as args, in which case only those specified are downloaded.
# (Allows invocation via *Picks.sh for out-of-date file updating).
#
# TODO: .  Due to the specific nature of the regex used to pull out the image
#          links from each site, a minor change to a source site could result
#          in empty files being created until this script is updated to
#          reflect the source site changes.
#          It could be better for this script to be run in a central location
#          so that this change is only made once by a single maintainer, and
#          for SkyPicks.sh to pull the lists down from that central location
#          instead of relying on the local output of this script. File 'ages'
#          could be used in *Picks.sh in order to prevent excessive d/ls.
#       .  Although /usr/script/scrapes seems to have become the facto standard
#          location for the image URL lists this doesn't fit with the purpose
#          of this dir. A dir within the '/usr/share/...' structure, ideally
#          within skin folder's 'Toppicks' dir itself is preferable.

# IF WGET SUPPORTS IT WE CAN UNCOMMENT EITHER OR BOTH OF THE FOLLOWING OPTIONS
# TO MAKE TRAFFIC FROM SITE SCRAPING LOOK LIKE 'NORMAL' WEB TRAFFIC
#referer='--referer="https://www.google.com/"'
#agent='--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"'

workdir="/usr/share/enigma2/scrapes"		# PREFER: /usr/share/enigma2/skin folder/Toppicks/scrapes
image_lists="new.txt store.txt premieres.txt living.txt one.txt atlantic.txt cinema.txt sports.txt cinematile.txt storetile.txt"

# If no filename passed on commmand line, then run for all files
if [ $# == 0 ]; then
  /bin/bash ${0} ${image_lists}
  exit 0
fi

if [ ! -d "${workdir}" ]; then
  mkdir -p "${workdir}" || exit 1
fi

while [[ $# -gt 0 ]]; do
  case ${1} in
    new.txt)       echo -n "Scraping Sky Coming-soon... "
                   wget -q ${agent} ${referer} "http://www.sky.com/tv/channel/skycinema/gallery/coming-soon-to-sky-cinema-premiere" -O -| \
                   grep -Eo "http://www.asset1.net/tv/pictures/movie/[a-zA-Z0-9./?=_-]*.jpg" | uniq | grep -ve "LB" -ve "do-not-publish" | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g' > ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    store.txt)     echo -n "Scraping DVD Releases... "
                   wget -q ${agent} ${referer} "https://www.sky.com/watch/channel/sky-cinema/new-premieres" -O -| \
                   grep -Eo "https://images.metadata.sky.com/pd-image/[a-zA-Z0-9./?=_-]*(300|380|700)" | sort | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    premieres.txt) echo -n "Scraping Sky New Premieres... "
                   wget -q ${agent} ${referer} --no-check-certificate "https://www.sky.com/watch/channel/sky-cinema/new-premieres" -O -| \
                   grep -Eo "https://images.metadata.sky.com/pd-image/[a-zA-Z0-9./?=_-]*" | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    living.txt)    echo -n "Scraping Sky Living... "
                   wget -q ${agent} ${referer} --no-check-certificate "https://www.sky.com/watch/channel/sky-living" -O -| \
                   grep -Eo "(https://www.sky.com/assets2/[a-zA-Z0-9./?=_-]*(jpg|png))|(https://dm8eklel4s62k.cloudfront.net/images/small/[a-zA-Z0-9./?=_-]*(jpg|png))" | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g' > ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    one.txt)       echo -n "Scraping Sky One... "
                   wget -q ${agent} ${referer} --no-check-certificate "https://www.sky.com/watch/channel/sky-one" -O -| \
                   grep -Eo "(https://www.sky.com/assets2/[a-zA-Z0-9./?=_-]*(jpg|png))|(https://dm8eklel4s62k.cloudfront.net/images/small/[a-zA-Z0-9./?=_-]*.(jpg|png))" | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    atlantic.txt)  echo -n "Scraping Sky Atlantic... "
                   wget -q ${agent} ${referer} --no-check-certificate "https://www.sky.com/watch/channel/sky-atlantic" -O -| \
                   grep -Eo "(https://www.sky.com/assets2/[a-zA-Z0-9./?=_-]*(jpg|png))|(https://dm8eklel4s62k.cloudfront.net/images/small/[a-zA-Z0-9./?=_-]*.(jpg|png))" | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    cinema.txt)    echo -n "Scraping Sky Cinema... "
                   wget -q ${agent} ${referer} "https://www.sky.com/watch/channel/sky-cinema/new-premieres" -O -| \
                   grep -Eo 'src="https://images.metadata.sky.com/pd-image/[a-zA-Z0-9./?=_-]*' | sort | uniq | \
sed 's|src="||g; s|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g; s|cover/[0-9]*|16-9/434?c=skycinema|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    sports.txt)    echo -n "Scraping Sky Sports Football... "
                   # Same regex also works with http://www.skysports.com/watch/tv-shows to include non-Football images
                   wget -q  ${agent} ${referer} "http://www.skysports.com/watch/tv-shows" -O -| \
                   grep -Eo "http://e[0-9].365dm.com/[a-zA-Z0-9./?=_-]*/([a-z]|[A-Z]){4}[a-zA-Z0-9_-]*.jpg" | uniq | \
                   sed 's|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                   ;;
    cinematile.txt)     echo -n "Scraping Sky Cinema Tile... "
                   wget -q ${agent} ${referer} "https://www.sky.com/watch/channel/sky-cinema/new-premieres" -O -| \
                   grep -Eo 'src="https://images.metadata.sky.com/pd-image/[a-zA-Z0-9./?=_-]*' | sort | uniq | \
sed 's|src="||g; s|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g; s|cover/[0-9]*|16-9/434?c=skycinema|g'> ${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"

                   ;;

	storetile.txt)     echo -n "Scraping Sky Store Tile... "
                   wget -q ${agent} ${referer} "https://www.sky.com/watch/channel/sky-cinema/new-premieres" -O -| \
                   grep -Eo 'src="https://images.metadata.sky.com/pd-image/[a-zA-Z0-9./?=_-]*' | sort | uniq | \
sed 's|src="||g; s|http|http://res.cloudinary.com/demo/image/fetch/f_png/http|g; s|cover/[0-9]*|16-9/434?c=skycinema|g'>${workdir}/${1}
                   [ -s ${workdir}/${1} ] && echo " -> ${1} OK" || echo " -> ${1} no valid links"
                  ;;

*)             echo -e "${1} not valid.\nValid files are: ${image_lists}"

                   ;;

  esac
  shift
done

exit 0
