import React from "react";
import { Button } from "@/components/ui/button";

export default function BuyToken() {
  return (
    <div className="text-center mt-6">
      <a
        href="https://app.uniswap.org/#/swap?inputCurrency=ETH&outputCurrency=0xTON_HRTK_TOKEN_ADDRESS&chain=ethereum"
        target="_blank"
        rel="noopener noreferrer"
      >
        <Button className="bg-purple-600 hover:bg-purple-700 text-white">
          🛒 Acheter HRTK sur Uniswap
        </Button>
      </a>
    </div>
  );
}
