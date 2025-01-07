#!/bin/sh

if [ -z "$GPG_KEY_ID" ]; then
    echo "GPG_KEY_ID is missing" >&2
    exit 1
fi
echo "trusted-key $GPG_KEY_ID" >> $HOME/.gnupg/gpg.conf

if [ -z "$GPG_PASSPHRASE" ]; then
    echo "GPG_PASSPHRASE is missing" >&2
    exit 1
fi
echo "passphrase $GPG_PASSPHRASE" >> $HOME/.gnupg/gpg.conf

pcscd --info --foreground --color --disable-polkit &
sleep 5

gpg --card-status
sleep infinity
