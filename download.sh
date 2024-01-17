#!/bin/bash

mkdir -pv pages

cat README.md \
	| awk '
		/^###/ { year = substr($0,5) }
		/https/ {
			if (match($0, /^\* ([0-9]+)\/([0-9]+) - \[(.*)\]\((.*)\)/, a)) {
				month = a[1]
				date = a[2]
				title = a[3]
				url = a[4]
				printf "%04d-%02d-%02d\t%s\t%s\n", year, month, date, url, title
			}
		}' \
	| sort \
	| while read DATE URL TITLE; do
		echo ===========================
		echo $DATE $URL $TITLE
		if [ ! -e "pages/${DATE}_${TITLE}.html" ]; then
			wget \
				--page-requisites \
				--html-extension \
				--restrict-file-names=windows \
				-O "pages/${DATE}_${TITLE}.html" \
				"${URL}"
		fi
	done
