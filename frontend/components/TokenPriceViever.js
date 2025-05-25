import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";

export default function TokenPriceViewer() {
  const [price, setPrice] = useState(null);
  const [loading, setLoading] = useState(true);

  // Remplacer ces adresses par celles du token EQT et du pool Uniswap
  const EQT_TOKEN_ADDRESS = "0xYourEquiTokenAddress";
  const WETH_ADDRESS = "0xC02aaa39b223FE8D0A0e5C4F27eAD9083C756Cc2"; // WETH sur Ethereum Mainnet
  const UNISWAP_POOL_ADDRESS = "0xYourUniswapPairAddress";

  const getPriceFromPool = async () => {
    try {
      const provider = new ethers.providers.JsonRpcProvider("https://mainnet.infura.io/v3/YOUR_INFURA_KEY");
      const pairABI = [
        "function getReserves() view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)",
        "function token0() view returns (address)",
        "function token1() view returns (address)"
      ];
      const pairContract = new ethers.Contract(UNISWAP_POOL_ADDRESS, pairABI, provider);
      const [reserve0, reserve1] = await pairContract.getReserves();
      const token0 = await pairContract.token0();
      const token1 = await pairContract.token1();

      let priceCalculated;
      if (token0.toLowerCase() === EQT_TOKEN_ADDRESS.toLowerCase()) {
        priceCalculated = reserve1 / reserve0;
      } else {
        priceCalculated = reserve0 / reserve1;
      }

      setPrice(priceCalculated);
    } catch (err) {
      console.error("Erreur lors de la récupération du prix:", err);
      setPrice(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    getPriceFromPool();
  }, []);

  return (
    <Card className="max-w-md mx-auto mt-10 text-center">
      <CardContent>
        <h2 className="text-xl font-bold mb-4">Prix actuel du token EQT</h2>
        {loading ? (
          <p>Chargement...</p>
        ) : price ? (
          <p>1 EQT ≈ {price.toFixed(6)} ETH</p>
        ) : (
          <p>Impossible de récupérer le prix.</p>
        )}
        <Button onClick={getPriceFromPool} className="mt-4">🔄 Rafraîchir le prix</Button>
      </CardContent>
    </Card>
  );
}
