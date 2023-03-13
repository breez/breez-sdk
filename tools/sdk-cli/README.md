# sdk-cli

A simple cli tool that sends commands to the sdk.

## Run
```cargo run```

On first run the cli will create bip39 mnemonics and save them at the current directory in a file called phrase.
First thing we need to create a node and there are three ways (commands) to do it:
* register_node - registers a new node in the cloud and receive credentials. The credentials are saved in the current directory (creds file)
* recover_node - recovers a node from bip39 mnemonics that exists in the current directory.
* init - initialize an existing node from credentials (creds file)

Once the node is created we can start send commands to the node. The cli is very simple and only intends to demonstrate the usage and investigate issues that are hard to debug on mobile platforms.