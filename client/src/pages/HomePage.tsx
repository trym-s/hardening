import React from "react";
import { Box, Typography } from "@mui/material";
import { Header } from "../components/Header";
import { Hero } from "../components/Hero";
import { Features } from "../components/Features";
import { ChatWidget } from "../components/ChatWidget";

export const HomePage: React.FC = () => {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        minHeight: "100vh",
        position: "relative",
      }}
    >
      <Header />

      <Box component="main" sx={{ flexGrow: 1 }}>
        <Hero />

        {/* Divider */}
        <Box
          sx={{
            height: "1px",
            background:
              "linear-gradient(90deg, transparent, rgba(255,255,255,0.08), transparent)",
            my: 8,
            maxWidth: 'md',
            mx: 'auto'
          }}
        />

        <Features />
      </Box>

      {/* Footer */}
      <Box
        component="footer"
        sx={{
          py: 6,
          textAlign: "center",
          borderTop: "1px solid rgba(255,255,255,0.05)",
          mt: "auto",
          bgcolor: "#09090b",
        }}
      >
        <Typography variant="body2" color="text.secondary">
          © 2024 System Hardener AI. Open Source Security.
        </Typography>
      </Box>

      <ChatWidget />
    </Box>
  );
};
