import "../globals.css";
import { ThemeProvider } from "../providers/theme-provider";

export default function LoginLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <ThemeProvider>{children}</ThemeProvider>;
}
