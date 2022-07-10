import { useRef, useEffect } from "react";

function MarketplaceContract({ value }) {
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
  uint256 value = `}

          <span className="secondary-color" ref={spanEle}>
            <strong>{value}</strong>
          </span>

          {`;

  function create() public view returns (NFT) {

    return NFT;
  }

  function write(uint256 newValue) public {
    value = newValue;
  }
}`}
        </code>
    );
}

export default MarketplaceContract;
