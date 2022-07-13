import {BrowserRouter, Routes, Route} from "react-router-dom"
import logo from './logo.png';
import './App.css';
import Navigation from './Navbar'
import {useState} from 'react';
import {ethers} from 'ethers';
import MarketPlaceAddress from '../contractsData/MarketPlace-address.json'
import MarketPlaceAbi from '../contractsData/NFT.json'
import NFTAddress from '../contractsData/NFT-address.json'
import NFTAbi from '../contractsData/NFT.json'
import Home from "./Home"
import Create from './Create'
import MyListedItem from './MyListedItem'
import MyPurchases from './MyPurchases'
import {Spinner} from 'react-bootstrap'
 
function App() {
  const [account, setAccount] = useState(null);
  const [loading, setLoading] = useState(true)
  const [nft, setNFT] = useState("")
  const [marketplace, setMarketPlace] = useState("")

  const web3Handler = async () => {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    setAccount(accounts[0])
    // Get provider from Metamask
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    // Set signer
    const signer = provider.getSigner()

    window.ethereum.on('chainChanged', (chainId) => {
      window.location.reload();
    })

    window.ethereum.on('accountsChanged', async function (accounts) {
      setAccount(accounts[0])
      await web3Handler()
    })
    loadContracts(signer) 
  }

  const loadContracts = async (signer) => {
    const marketplace = new ethers.Contract(MarketPlaceAddress.address, MarketPlaceAbi.abi, signer)
    setMarketPlace(marketplace)
    const nft =  new ethers.Contract(NFTAddress.address, NFTAbi.abi, signer)
    setNFT(nft)
    setLoading(false)
  }
  return (
  <BrowserRouter>
    <div className="App">
     <Navigation web3Handler={web3Handler} account={account}/>
     {loading ? (<div style={{display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '80vh'}}>
      <Spinner animation='border' style={{display: 'flex'}}/>
      <p className='mx-3 my-0'>Awaiting MetaMask Connection...</p>
      </div>) :
      (<Routes>
      <Route path="/" element={<Home marketplace={marketplace} nft={nft}/>} />
      <Route path="/create" element={<Create marketplace={marketplace} nft={nft}/>} />
      <Route path="/my-items" element={<MyListedItem marketplace={marketplace} nft={nft} account={account}/> } />
      <Route path="/my-purchases" element={<MyPurchases marketplace={marketplace} nft={nft} account={account}/>}/>
     </Routes>)}
    </div>
  </BrowserRouter>
  );
}

export default App;
