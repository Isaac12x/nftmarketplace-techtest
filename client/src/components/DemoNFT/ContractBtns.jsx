import { useState } from "react";
import { toast } from 'react-toastify';
import useEth from "../../contexts/EthContext/useEth";

function ContractBtns({ setValue }) {
  const { state: { contract, accounts } } = useEth();
  const [tokenId, setTokenId] = useState("");

  const handleInputChange = e => {
    if (/^\d+$|^$/.test(e.target.value)) {
      setInputValue(e.target.value);
    }
  };

   const mint = async e => {
       if (e.target.tagName === "INPUT") {
           return;
       }
       if (tokenId === "") {
           alert("Please enter a value to write.");
           return;
       }

       const newValue = parseInt(tokenId);
       const value = await contract.methods.mint(newValue).call({ from: accounts[0] });
       setTokenId(value);
    };


  const transferFrom = async e => {
    if (e.target.tagName === "INPUT") {
      return;
    }
    if (inputValue === "") {
      alert("Please enter a value to write.");
      return;
    }
    const newValue = parseInt(inputValue);

    await contract.methods.write(newValue).send({ from: accounts[0] });
  };

  return (
    <div className="btns">

      <button onClick={mint}>
        mint(<input
               type="text"
               placeholder="new url"
               value={inputURL}
               onChange={handleURLChange}
             />)
      </button>

      <div onClick={transferFrom} className="input-btn">
        transferFrom(<input
          type="text"
          placeholder="new url"
          value={inputValue}
          onChange={handleInputChange}
        />
        <input
          type="text"
          placeholder="new url"
          value={inputValue}
          onChange={handleInputChange}
        />
        <input
          type="text"
          placeholder="new url"
          value={inputValue}
          onChange={handleInputChange}
        />)
      </div>

    </div>
  );
}

export default ContractBtns;
