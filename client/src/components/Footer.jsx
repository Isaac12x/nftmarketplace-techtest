function Link({ uri, text }) {
  return <a href={uri} target="_blank" rel="noreferrer">{text}</a>;
}

function Footer() {
  return (
    <footer>
      <h2>Resources used!</h2>
      <Link uri={"https://trufflesuite.com"} text={"Truffle"} />
      <Link uri={"https://reactjs.org"} text={"React"} />
      <Link uri={"https://soliditylang.org"} text={"Solidity"} />
      <Link uri={"https://ethereum.org"} text={"Ethereum"} />
      <Link uri={"https://docs.openzeppelin.com/contracts/4.x/"} text={"Open Zeppelin"}/>
    </footer >
  );
}

export default Footer;
