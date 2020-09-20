#/bin/bash

# Check for dependencies
r=($(which jq|wc -l))
if [ $r -eq 0 ]; then
    echo "This test script relies upon jq, a command line JSON processor to run."
    echo "See guidance here for installation in your environment"
    echo "https://stedolan.github.io/jq/download/"
    exit 1
fi

# Keystore 1
key1name=$(cat $1 | jq -r .extendedPublicKeys[0].name)
key1path=$(cat $1 | jq -r .extendedPublicKeys[0].bip32Path)
key1xpub=$(cat $1 | jq -r .extendedPublicKeys[0].xpub)
if [[ "$key1name" == "unchained" ]]; then
    echo "Keystore 1 is the Unchained Capital key for this wallet"
    key1type="bip32"
else
    echo "Keystore 1 is $key1name with path $key1path. Choose the hardware wallet type"
    PS3='Is this a Ledger or Trezor: '
    options1=("Ledger" "Trezor")
    select opt1 in "${options1[@]}"
    do
        case $opt1 in
            "Ledger")
                key1type="ledger"
                break
                ;;
            "Trezor")
                key1type="trezor"
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
fi

# Keystore 2
key2name=$(cat $1 | jq -r .extendedPublicKeys[1].name)
key2path=$(cat $1 | jq -r .extendedPublicKeys[1].bip32Path)
key2xpub=$(cat $1 | jq -r .extendedPublicKeys[1].xpub)
if [[ "$key2name" == "unchained" ]]; then
    echo "Keystore 2 is the Unchained Capital key for this wallet"
    key2type="bip32"
else
    echo "Keystore 2 is $key2name with path $key2path. Choose the hardware wallet type"
    PS3='Is this a Ledger or Trezor: '
    options2=("Ledger" "Trezor")
    select opt2 in "${options2[@]}"
    do
        case $opt2 in
            "Ledger")
                key2type="ledger"
                break
                ;;
            "Trezor")
                key2type="trezor"
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
fi

# Keystore 3
key3name=$(cat $1 | jq -r .extendedPublicKeys[2].name)
key3path=$(cat $1 | jq -r .extendedPublicKeys[2].bip32Path)
key3xpub=$(cat $1 | jq -r .extendedPublicKeys[2].xpub)
if [[ "$key3name" == "unchained" ]]; then
    echo "Keystore 3 is the Unchained Capital key for this wallet"
    key3type="bip32"
else
    echo "Keystore 3 is $key3name with path $key3path. Choose the hardware wallet type"
    PS3='Is this a Ledger or Trezor: '
    options3=("Ledger" "Trezor")
    select opt3 in "${options3[@]}"
    do
        case $opt3 in
            "Ledger")
                key3type="ledger"
                break
                ;;
            "Trezor")
                key3type="trezor"
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
fi

# Determine output name from input filename
outputfile=$(echo $2)
if [[ "$outputfile" == "" ]]; then
    outputfile=$(echo $1 | sed -e s/\.json/\.electrum.json/)
fi
echo "Writing converted file to $outputfile"

# Now assemble in Electrum format
# open json object with wallet definition
echo "{\"wallet_type\":\"2of3\"" > $outputfile
# keystore 1
echo ",\"x1/\":{\"label\":\"$key1name\"," >> $outputfile
if [[ "$key1type" == "bip32" ]]; then
    echo "\"type\":\"bip32\",\"xprv\":null,\"derivation\":null,\"pw_hash_version\":1" >> $outputfile
else
    echo "\"type\":\"hardware\",\"hw_type\":\"$key1type\",\"derivation\":\"$key1path\"" >> $outputfile
fi
echo ",\"xpub\":\"$key1xpub\"}" >> $outputfile
# keystore 2
echo ",\"x2/\":{\"label\":\"$key2name\"," >> $outputfile
if [[ "$key2type" == "bip32" ]]; then
    echo "\"type\":\"bip32\",\"xprv\":null,\"derivation\":null,\"pw_hash_version\":1" >> $outputfile
else
    echo "\"type\":\"hardware\",\"hw_type\":\"$key2type\",\"derivation\":\"$key2path\"" >> $outputfile
fi
echo ",\"xpub\":\"$key2xpub\"}" >> $outputfile
# keystore 3
echo ",\"x3/\":{\"label\":\"$key3name\"," >> $outputfile
if [[ "$key3type" == "bip32" ]]; then
    echo "\"type\":\"bip32\",\"xprv\":null,\"derivation\":null,\"pw_hash_version\":1" >> $outputfile
else
    echo "\"type\":\"hardware\",\"hw_type\":\"$key3type\",\"derivation\":\"$key3path\"" >> $outputfile
fi
echo ",\"xpub\":\"$key3xpub\"}" >> $outputfile
# close out the json
echo "}" >> $outputfile
