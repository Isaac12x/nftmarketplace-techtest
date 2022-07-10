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
      {`contract Marketplace {
  uint256 value = `}

      <span className="secondary-color" ref={spanEle}>
        <strong>{value}</strong>
      </span>

      {`;

  function list(uint256 _price, string _for ) public view returns (uint256) {
    return value;
  }

  function sell(uint256 newValue) public {
    value = newValue;
  }

  function sell(uint256 newValue) public {
    value = newValue;
  }

}`}
    </code>
  );
}

export default Contract;
