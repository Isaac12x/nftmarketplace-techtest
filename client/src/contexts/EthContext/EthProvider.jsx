import React, { useReducer, useCallback, useEffect, useState } from "react";
import { toast } from 'react-toastify';
import Web3 from "web3";
import EthContext from "./EthContext";
import { reducer, actions, initialState } from "./state";

function EthProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);
    const [connection, setConnection] = useState({errored: false, showConnected: 0, conntected: false});

  const init = useCallback(
    async artifact => {
        if (artifact) {
        const web3 = new Web3(Web3.givenProvider || "ws://local host:8545");
        const accounts = await web3.eth.requestAccounts();
        const networkID = await web3.eth.net.getId();
        const { abi1, abi2 } = artifact;
            let address, nftContract, marketplaceContract;
        try {
          address = artifact.networks[networkID].address;
          nftContract = new web3.eth.Contract(abi1, process.env.NFTADDRESS);
          marketplaceContract = new web3.eth.Contract(abi2, process.env.MARKETPLACEADDRESS);
          setConnection({connected: true});
        } catch (err) {
          setConnection({errored: true, connected: false});
          console.error(err);
        }
        dispatch({
          type: actions.init,
            data: { artifact, web3, accounts, networkID, nftContract, marketplaceContract }
        });
      }
    }, []);

  

  useEffect(() => {
    const tryInit = async () => {
      try {
        const nft = require("../../contracts/Configured.json");
          const marketplace = require("../../contracts/FuncMarketplace.json");
         init(nft, marketplace);


          // TODO: needs refinement
          window.localStorage.setItem('connection', JSON.stringify(connection));
          if (connection.errored === false && connection.showConnected === 0) {
              toast.success("Metamask connected");
              setConnection({showConnected: 1});
          }
          if (connection.errored === true && connection.showConnected === 0) {
              toast.error("Not connected");
          }
      } catch (err) {
        console.error(err);
      }
    };

    tryInit();
  }, [init]);


  /// persist between page reloads
  useEffect(() => {
        setConnection(JSON.parse(window.localStorage.getItem('connection')));
    }, []);

   useEffect(() => {
        window.localStorage.setItem('connection', connection);
    }, [connection]);

  useEffect(() => {
    const events = ["chainChanged", "accountsChanged"];
    const handleChange = () => {
      init(state.artifact);
    };

    events.forEach(e => window.ethereum.on(e, handleChange));
    return () => {
      events.forEach(e => window.ethereum.removeListener(e, handleChange));
    };
  }, [init, state.artifact]);

  return (
    <EthContext.Provider value={{
      state,
      dispatch
    }}>
      {children}
    </EthContext.Provider>
  );
}

export default EthProvider;
