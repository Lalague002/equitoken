import React from "react";
import ConnectWallet from "../components/ConnectWallet";
import TokenPriceViewer from "../components/TokenPriceViewer";
import BuyToken from "../components/BuyToken";
import ClaimDividends from "../components/ClaimDividends";
import GovernancePanel from "../components/GovernancePanel";

// ABI et adresse du contrat à personnaliser
import abi from "../abi/EquiToken.json";

const CONTRACT_ADDRESS = "0xTON_ADRESSE_EQT";

export default function Dashboard() {
  return (
    <div className="p-6 max-w-3xl mx-auto">
      <h1 className="text-2xl font-bold text-center mb-8">Tableau de bord EquiToken 🐎</h1>

      <ConnectWallet />
      <TokenPriceViewer />
      <BuyToken />

      <section className="mt-10">
        <h2 className="text-xl font-semibold mb-4">💰 Réclamer vos dividendes</h2>
        <ClaimDividends contractAddress={CONTRACT_ADDRESS} abi={abi} />
      </section>

      <section className="mt-10">
        <h2 className="text-xl font-semibold mb-4">🗳 Gouvernance communautaire</h2>
        <GovernancePanel />
      </section>
    </div>
  );
}
