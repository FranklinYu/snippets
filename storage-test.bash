#!/bin/bash

# Usage: CARD='/Volumes/MY CARD' sh storage-test.bash

set -o errexit -o pipefail -o nounset

num=${NUM:-20}
folder=${FOLDER:-test-files}
log_file=${LOG_FILE:-log}
card=${CARD%/}
unset NUM FOLDER LOG_FILE CARD

print_message() {
	tput setaf 2 # green
	echo "$@"
	tput sgr0
}
print_error() {
	tput setaf 1 # red
	>&2 echo "$@"
	tput sgr 0
}

old_cksum='old.md5'
new_cksum='new.md5'

if [ -z "$card" ]; then
	print_error "Option <CARD> required."
	exit 1
fi

truncate -s 0 "$old_cksum" "$new_cksum" "$log_file"

mkdir -p "$folder"

if !( [ -d "$CARD" ] && [ -r "$CARD" ] && [ -w "$CARD" ] ); then
	print_error "<$CARD> is not a readable-writable directory."
	exit 1
fi

print_message "Saving test files to folder <$folder>..."
for i in $(seq "$num"); do
	filename="$folder/$i"
	dd if=/dev/urandom of="$filename" count=10 bs=1m 2>> "$log_file"
	truncate -s 1g "$filename"
	md5 "$filename" >> "$old_cksum"
done

print_message "Moving <$folder> to <$CARD>..."
rsync --ignore-times --progress --recursive "$folder" "$CARD"

print_message 'Moving back...'
rsync --ignore-times --progress --recursive "$CARD/$folder" .

print_message 'Checking MD5...'
for i in $(seq "$num"); do
	filename="$folder/$i"
	md5 "$filename" >> "$new_cksum"
done
if cmp --silent "$old_cksum" "$new_cksum"; then
	print_message "Congratulations! <$CARD> is fine."
else
	print_error 'MD5 does not match.'
fi
