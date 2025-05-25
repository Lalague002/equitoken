import React, { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";

export default function ConnectWallet() {
  const [walletAddress, setWalletAddress] = useState(null);

  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
        setWalletAddress(accounts[0]);
      } catch (error) {
        console.error("Erreur de connexion à MetaMask :", error);
      }
    } else {
      alert("MetaMask n'est pas installé. Veuillez l’ajouter à votre navigateur.");
    }
  };

  useEffect(() => {
    if (window.ethereum && window.ethereum.selectedAddress) {
      setWalletAddress(window.ethereum.selectedAddress);
    }
  }, []);

  return (
    <div className="text-center mb-4">
      {walletAddress ? (
        <p className="text-sm text-green-600">Connecté : {walletAddress.slice(0, 6)}...{walletAddress.slice(-4)}</p>
      ) : (
        <Button onClick={connectWallet}>🔐 Se connecter avec MetaMask</Button>
      )}
    </div>
  );
}
