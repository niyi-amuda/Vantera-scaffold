import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Vantera | Premium Smartphone Pre-Orders",
  description:
    "Reserve the future. Vantera offers premium smartphones for pre-order across Nigeria.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
