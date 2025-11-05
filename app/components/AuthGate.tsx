import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { authHeaders } from "../lib/auth";

export default function AuthGate({ children }: { children: React.ReactNode }) {
  const navigate = useNavigate();
  const [checked, setChecked] = useState(false);
  const [valid, setValid] = useState(false);

  useEffect(() => {
    try {
      const token = localStorage.getItem("jwt");
      if (!token) {
        navigate("/login", { replace: true });
        return;
      }
    } catch {
      navigate("/login", { replace: true });
      return;
    }
    setChecked(true);
    // Soft-validate token by calling /users/me; if unauthorized, redirect
    const apiBase = import.meta.env.VITE_API_BASE || "/api";
    fetch(`${apiBase}/users/me`, { headers: authHeaders() as HeadersInit })
      .then((r) => {
        if (r.ok) {
          setValid(true);
        } else {
          // Clear bad token and redirect
          try {
            localStorage.removeItem("jwt");
          } catch {}
          navigate("/login", { replace: true });
        }
      })
      .catch(() => {
        // Network/API down — still block access
        try {
          localStorage.removeItem("jwt");
        } catch {}
        navigate("/login", { replace: true });
      });
  }, [navigate]);

  if (!checked || !valid) return null;
  return <>{children}</>;
}
