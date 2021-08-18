# logik-genesis-contracts

## The Plug 

### Notes for completing The Plug (pre-production)
- IPFS hashes need to be updated with **new JSON pins** (need to research "About" section)
  -> https://docs.opensea.io/docs/metadata-standards'

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
**Working on the assumption that all of these NFT's are basically unrelated unless viewed
on LOGIK's website**

### Passport
- `Passport` should have a mapping from owner addresses to stamp balances (bridged w/ the address 
for the collection), i.e. 
```
  // Passport.sol
  // mapping from owner addresses to stamp balances (bridged w/ the address for the collection)
  mapping (address => mapping(address => uint32[]) 
  // e.g.
  // 0xEab64..Gz9 => [0x8a..er3 => [0,1,1,0,0,0,1], ...]
  // means owner 0xEa.. has collected stamps 1, 2, and 7 from the collection at address 0x8a..
```
- This means we need a function: 
	`awardStamp(address passportOwner, address stamp, uint256 stampId)`

- Maybe also:
	`awardCitizen(address passportOwner, address citizen, uint256 citizenId)`

- Normal functions I can think of:
	`beforeTransfer`
	`tokenURI` (the cover of the passport will be different if you own a character???)
	`mintPassport`

- *Does anything change if you also mint a character??? Or is this just the first page
  of the passport if so????*

### Stamp Collection
- This will communicate directly with `Passport.sol` in order to validate whether or not 
  someone is allowed to mint a stamp
- Each collection will be a new contract where NUM_PASSPORTS Stamps get minted
- The URI returned should never change, but should at least be unique on IPFS (API can handle
  this)
- Pretty sure these should be simple, while Passport is more complicated than I currently have 
  documented...

### Citizen
- The main thing with the Citizens is some sort of hash function that determines the URI (because 
  it will be a random, unique citizen determined by something like the minter's address)
- The API will be doing the heavy lifting as far as the logic is concerned 
  -> I think it needs to use the minter's address to assemble a Character (using layers) 
     and then in-turn pin it to IPFS using Pinata's API, then pin a JSON file that corresponds
     to it, and then deliver that final IPFS hash back to the contract for the URI.
- Maybe this also communicates with `Passport.sol` in order to "award" a Citizen






















