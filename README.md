# Caravan2Electrum
A simple script for converting a Caravan configuration file to Electrum wallet configuration

This script is based on the Caravan wallet file produced from an Unchained Capital vault for External Spending Information 

It uses basic bash string comparisons and depends on the jq tool being installed.

# Setup
You can clone this repo, and then mark the convert.sh as executable after review

```sh
git clone git@github.com:lucasmoten/caravan2electrum.git
cd caravan2electrum
chmod +x ./convert.sh
```

# Running the script
To run, you can specify either 1 or 2 arguments.

The first argument should be the path of the unchained capital wallet configuration file to be converted.
The second argument, if given, will be used as the output filename.  If not provided, the output filename will be the same as the input with a file extension of ".electrum.json"

```sh
./convert.sh path-to-wallet-configuration.json
```

For each key that is not the Unchained Capital key, you will be prompted whether it is a Ledger or a Trezor


# Sample Files
In the samples folder are two files.  

- __input-caravan.json__

  This file is a copy of a wallet configuration file for a vault I had previously used for testing purposes in Unchained Capital.

- __output-electrum.json__

  This is the equivalent structure of the input file, but in a format suitable for Electrum.


# Demo using Sample Files
You can use the script with the input file as follows, and specify a second argument for the electrum file to create
```sh
./convert.sh samples/input-caravan.json samples/electrum-sample.json
```

Answer either ledger or trezor for each device when prompted.  It doesn't matter which since you won't be able to spend funds without having the master private key anyway.

A file will be generated at samples/electrum-sample.json

From your Electrum wallet facilitator, open that file.  Once it syncs transactions, you will see transactions and addresses.