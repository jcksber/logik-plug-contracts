# logik-genesis-contracts

## The Plug 

### Notes for completing The Plug (pre-production)
- Need to **make Plug.sol upgradable** just in case for emergencies in the future
- IPFS hashes need to be updated with **new JSON pins** (need to research "About" section)
  -> https://docs.opensea.io/docs/metadata-standards

### Notes for transitioning to Production
- New **Alchemy API key** (production version)
- Need to **deploy using our shared wallet** (not my personal MetaMask) - 
  so **update public/private keys**
- Need to setup `hardhat.config.js` for Ethereum mainnet 
- Switch logic from cycling the asset from every 2 hours to **every 2 months**

#### Post-production if anything
- Potentially write a script that LOGIK can execute on his own to obtain the list of
  level owners so that I don't need to do it for him every time he wants an updated list
- Script that can auto batch transfer the airdrops based on a list of addresses


## Citizens of the World

### Passport

### Stamp Collection

### Citizen
