import { ConnectButton, useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";
import { ToastContainer } from "react-toastify";
import PortfolioView from "./views/PortfolioView";
import { useEffect } from "react";
import "./App.css";

function App() {
  const account = useCurrentAccount();

  // Fetch SUI balance
  const { data: balanceData } = useSuiClientQuery(
    "getBalance",
    { owner: account?.address as string },
    { enabled: !!account, retry: 0 }
  );

  const getSuiBalance = () => {
    if (!balanceData) return "0.00";
    return (Number(balanceData.totalBalance) / 1_000_000_000).toFixed(2);
  };

  // Suppress wallet console errors/toasts
  useEffect(() => {
    const originalConsoleError = console.error;
    console.error = (...args) => {
      const msg = args.join(" ");
      if (msg.toLowerCase().includes("wallet") || msg.toLowerCase().includes("dapp-kit")) return;
      originalConsoleError.apply(console, args);
    };
    return () => {
      console.error = originalConsoleError;
    };
  }, []);

  return (
    <div>
      <ToastContainer position="top-right" theme="dark" autoClose={3000} hideProgressBar={false} />

      {/* HEADER */}
      <header className="app-header">
        <div className="header-content">
          <div className="header-logo">
            <img src="/sui-logo.png" alt="Sui Logo" />
            <h1>Smart Contracts Code Camp Portfolio</h1>
          </div>
        </div>
      </header>

      {/* Wallet Status Banner */}
      {account && (
        <div className="wallet-banner">
          <div className="wallet-banner-content">
            <div className="wallet-info">
              <div className="wallet-dot"></div>
              <div>
                <div style={{ display: "flex", gap: "15px", alignItems: "center" }}>
                  <span style={{ color: "#22c55e", fontWeight: 600 }}>Wallet Connected</span>
                  <span style={{ color: "#64748b" }}>|</span>
                  <span style={{ color: "#cbd5e1" }}>
                    Balance: <strong>{getSuiBalance()} SUI</strong>
                  </span>
                </div>
                <div style={{ color: "#86efac", fontSize: "0.875rem", marginTop: "4px" }}>
                  {account.address.slice(0, 8)}...{account.address.slice(-6)}
                </div>
              </div>
            </div>
            <div style={{ color: "#94a3b8", fontSize: "0.875rem" }}>Viewing your portfolio</div>
          </div>
        </div>
      )}

      {/* MAIN CONTENT */}
      <main>
        <PortfolioView />
      </main>
    </div>
  );
}

export default App;
