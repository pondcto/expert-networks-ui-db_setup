import React from "react";
import "./globals.css";
import ClientProviders from "./providers/client-providers";

interface RootLayoutProps {
  children: React.ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <ClientProviders>
      {children}
    </ClientProviders>
  );
}
