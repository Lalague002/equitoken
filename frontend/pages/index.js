import React from "react";
import Dashboard from "./dashboard";

export default function Home() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-4 text-center">Bienvenue sur EquiToken 🐎</h1>
      <Dashboard />
    </div>
  );
}

