#!/bin/bash

verify_IP() {
   local file_ip="$1"
   local hostname="$2"

   if ! nslookup "$hostname" | grep -q "$file_ip"; then
     echo "Bogus IP for $hostname in $HOME/etc/hosts!"
     return 1
   fi
   return 0
}

if [ -z "$1" ] || [ ! -f "$1" ]; then
   echo "Error: file '$1' does not exist." >&2
   exit 1
fi

while read -r ip name; do
   if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
     continue
   fi
   if [ "$name" = "localhost" ] || [ "$name" = "lina-virtual-machine" ] || [[ "$name" == ip6-* ]]; then
     continue
   fi

   verify_IP "$ip" "$name"

done < "$1"
