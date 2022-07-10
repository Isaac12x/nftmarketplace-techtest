import { useRef, useEffect } from "react";

function Contract({ value }) {
  const spanEle = useRef(null);

  useEffect(() => {
    spanEle.current.classList.add("flash");
    const flash = setTimeout(() => {
      spanEle.current.classList.remove("flash");
    }, 300);
    return () => {
      clearTimeout(flash);
    };
  }, [value]);

  return (
    <code>
      {`contract NFTWrapper {
 string memory tokenURI = `}

      <span className="secondary-color" ref={spanEle}>
        <strong>{value}</strong>
      </span>

      {`;

 string memory name = `}

      <span className="secondary-color" ref={spanEle}>
        <strong>{value}</strong>
      </span>

      {`;



 string memory symbol = `}

      <span className="secondary-color" ref={spanEle}>
        <strong>{value}</strong>
      </span>

      {`;





   function mint((string memory tokenURI) public view returns (uint256) {
       ...
       return newItemId;
   }

   function name() public view virtual override returns (string memory) {
       return _name;
   }

   function symbol() public view virtual override returns (string memory) {
       return _symbol;
   }

   function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
       ...
       _transfer(from, to, tokenId);
    }
  

  
}`}
    </code>
  );
}

export default Contract;
