import { EthProvider } from "./contexts/EthContext";
import { ToastContainer } from "react-toastify";
import Intro from "./components/Intro/";
import Setup from "./components/Setup";
import Demo from "./components/DemoNFT";
import Demo2 from "./components/DemoMarketplace";
import Footer from "./components/Footer";

import "./App.css";
import "react-toastify/dist/ReactToastify.min.css";

function App() {
  return (
    <EthProvider>
      <div id="App" >
        <div className="container">
          <ToastContainer
            position="top-right"
            autoClose={5000}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />
          <Intro />
          <hr />
          <Setup />
          <hr />
          <Demo />

          <Demo2 />
          <hr />
          <Footer />
        </div>
      </div>
    </EthProvider>
  );
}

export default App;
