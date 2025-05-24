// Ce code est écrit en JavaScript (React) avec JSX et Tailwind CSS pour le style
// Il utilise aussi des composants UI de shadcn/ui et ajoute la connexion MetaMask

import React from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { BarChart3, Wallet, Users } from "lucide-react";

export default function EquiTokenApp() {
  return (
    <div className="p-6 max-w-5xl mx-auto">
      <h1 className="text-3xl font-bold mb-4">EquiToken</h1>
      <Tabs defaultValue="dashboard">
        <TabsList className="mb-4">
          <TabsTrigger value="dashboard"><BarChart3 className="mr-2" /> Dashboard</TabsTrigger>
          <TabsTrigger value="wallet"><Wallet className="mr-2" /> Mon portefeuille</TabsTrigger>
          <TabsTrigger value="dao"><Users className="mr-2" /> Gouvernance</TabsTrigger>
        </TabsList>

        <TabsContent value="dashboard">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <Card>
              <CardContent className="p-4">
                <p className="text-sm text-muted-foreground">Total de chevaux actifs</p>
                <p className="text-2xl font-bold">3</p>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="p-4">
                <p className="text-sm text-muted-foreground">Gains redistribués</p>
                <p className="text-2xl font-bold">25 000 €</p>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="p-4">
                <p className="text-sm text-muted-foreground">Prochaines courses</p>
                <p className="text-2xl font-bold">2 prévues</p>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        <TabsContent value="wallet">
          <Card>
            <CardContent className="p-4">
              <h2 className="text-xl font-semibold mb-2">Mes EQT</h2>
              <div className="flex items-center space-x-4">
                <p className="text-2xl font-bold">12 500 EQT</p>
                <Button>Recevoir des gains</Button>
              </div>
              <div className="mt-4">
                <Input placeholder="Adresse de destination" className="mb-2" />
                <Button>Envoyer</Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="dao">
          <Card>
            <CardContent className="p-4">
              <h2 className="text-xl font-semibold mb-2">Propositions DAO</h2>
              <ul className="list-disc pl-5 space-y-2">
                <li>Acquisition d’un nouveau cheval (vote en cours)</li>
                <li>Réallocation des fonds marketing</li>
              </ul>
              <div className="mt-4">
                <Button>Créer une proposition</Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
