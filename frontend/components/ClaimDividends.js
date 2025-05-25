import React, { useState } from 'react';
import { ethers } from 'ethers';
import { Button } from '@/components/ui/button';

export default function ClaimDividends({ contractAddress, abi }) {
  const [walletAddress, setWalletAddress] = useState(null);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  const connectWallet = async () => {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      setWalletAddress(accounts[0]);
    } else {
      alert("Veuillez installer MetaMask.");
    }
  };

  const claimDividends = async () => {
    if (!window.ethereum || !walletAddress) {
      alert("Veuillez connecter votre wallet d'abord.");
      return;
    }

    try {
      setLoading(true);
      setMessage('');
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(contractAddress, abi, signer);

      const tx = await contract.claimDividends();
      await tx.wait();
      setMessage('✅ Dividendes réclamés avec succès !');
    } catch (err) {
      console.error(err);
      setMessage('❌ Erreur lors de la réclamation.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="text-center mt-8">
      {!walletAddress ? (
        <Button onClick={connectWallet}>Se connecter à MetaMask</Button>
      ) : (
        <Button onClick={claimDividends} disabled={loading}>
          {loading ? 'Traitement...' : '💰 Réclamer mes dividendes'}
        </Button>
      )}
      {message && <p className="mt-4 text-sm">{message}</p>}
    </div>
  );
}
