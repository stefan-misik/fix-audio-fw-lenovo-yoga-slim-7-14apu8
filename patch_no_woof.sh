#!/bin/sh


file=/usr/lib/firmware/ti/tas2781/TIAS2781RCA4.bin.zst

backup="$file.backup"


# Check if backup file exists
[ -e "$backup" -a "$1" != "-f" ] && ( echo "Old backup still exists, exiting..." ; exit 1 )


tmpin="$(mktemp -q)"
tmpout="$(mktemp -q)"

zstd -q -f -d "$file" -o "$tmpin"
hexdump -v -e '1/1 "%02X "' "$tmpin" | sed 's/00 00 5C D9/00 00 5C 19/g' | xxd -r -p - "$tmpout"
cp "$file" "$backup"
zstd -q -f -z "$tmpout" -o "$file"
rm "$tmpin" "$tmpout"

