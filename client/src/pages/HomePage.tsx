import React, { useState, useEffect, useRef } from "react";
import { Box, Container, Typography } from "@mui/material";
import { Header } from "../components/Header";
import { Hero } from "../components/Hero";
import { Features } from "../components/Features";
import { ChatWidget } from "../components/ChatWidget";

// ---------------------------
// 1. Terminal Component
// ---------------------------
interface TerminalProps {
  lines: Array<{ text: string; color?: string; id: number }>;
}

const TerminalPreview: React.FC<TerminalProps> = ({ lines }) => {
  const scrollRef = useRef<HTMLDivElement>(null);

// Scroll to bottom when new lines are added
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [lines]);

  return (
    <Container maxWidth="md" sx={{ mb: 12 }}>
      <Box
        sx={{
          borderRadius: 3,
          overflow: "hidden",
          boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.5)",
          border: "1px solid rgba(255,255,255,0.08)",
          bgcolor: "#09090b",
          fontFamily: '"JetBrains Mono", "Fira Code", monospace',
        }}
      >
        {/* Terminal Title Bar */}
        <Box
          sx={{
            px: 2,
            py: 1.5,
            bgcolor: "rgba(255,255,255,0.03)",
            borderBottom: "1px solid rgba(255,255,255,0.05)",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <Box sx={{ display: "flex", gap: 1 }}>
            <Box
              sx={{
                width: 10,
                height: 10,
                borderRadius: "50%",
                bgcolor: "#ef4444",
              }}
            />
            <Box
              sx={{
                width: 10,
                height: 10,
                borderRadius: "50%",
                bgcolor: "#f59e0b",
              }}
            />
            <Box
              sx={{
                width: 10,
                height: 10,
                borderRadius: "50%",
                bgcolor: "#22c55e",
              }}
            />
          </Box>
          <Typography
            variant="caption"
            sx={{
              color: "text.secondary",
              fontFamily: "inherit",
              opacity: 0.6,
            }}
          >
            root@server:~/hardening
          </Typography>
          <Box sx={{ width: 40 }} /> {/* Spacer for centering */}
        </Box>

        {/* Terminal Content Area */}
        <Box
          ref={scrollRef}
          sx={{
            p: 3,
            height: "300px",
            overflowY: "auto",
            fontSize: "0.85rem",
            lineHeight: 1.6,
            scrollBehavior: "smooth",
          }}
        >
          {lines.map((line) => (
            <Box key={line.id} sx={{ mb: 0.5 }}>
              <Typography
                component="span"
                sx={{
                  color: line.color || "text.secondary",
                  fontFamily: "inherit",
                  display: "block",
                }}
              >
                {/* We can use dangerouslySetInnerHTML to render HTML content (bold, etc.) 
                                        // or simply print text. For now, text. */ }
                {line.text}
              </Typography>
            </Box>
          ))}

          {/* Active Prompt Line */}
          <Box sx={{ display: "flex", gap: 1, mt: 1 }}>
            <Typography sx={{ color: "#22c55e", fontFamily: "inherit" }}>
              ➜
            </Typography>
            <Typography sx={{ color: "#83adb5", fontFamily: "inherit" }}>
              ~
            </Typography>
            <Box
              sx={{
                width: 8,
                height: 18,
                bgcolor: "text.secondary",
                animation: "blink 1s step-end infinite",
              }}
            />
          </Box>
        </Box>
      </Box>
      <style>{`
        @keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0; } }
      `}</style>
    </Container>
  );
};

// ---------------------------
// 2. Main Page Logic
// ---------------------------

// Default (initial) terminal lines
const INITIAL_LOGS = [
  { id: 1, text: "Welcome to System Hardener v2.0", color: "#a1a1aa" },
  {
    id: 2,
    text: "Type './hardening.sh --help' for options.",
    color: "#a1a1aa",
  },
// Empty line
];

export const HomePage: React.FC = () => {
  const [logs, setLogs] = useState(INITIAL_LOGS);

  const simulateDownloadLogs = () => {
    // Clear first or add a separator
    setLogs((prev) => [
      ...prev,
      {
        id: Date.now(),
        text: "----------------------------------------",
        color: "#52525b",
      },
      {
        id: Date.now() + 1,
        text: "$ wget https://hardener.ai/api/v1/script",
        color: "#e4e4e7",
      },
    ]);

    // Add timed logs
    const sequence = [
      { text: "[INFO] Resolving hardener.ai... 104.21.55.2", delay: 800 },
      {
        text: "[INFO] Connecting to hardener.ai|104.21.55.2|:443... connected.",
        delay: 1600,
      },
      {
        text: "[INFO] HTTP request sent, awaiting response... 200 OK",
        delay: 2400,
      },
      { text: "[INFO] Saving to: 'hardening.sh'", delay: 3000 },
      {
        text: "hardening.sh          100%[===================>]  14.5K  --.-KB/s    in 0.001s",
        delay: 3800,
        color: "#22c55e",
      },
      {
        text: "[SUCCESS] Script saved successfully.",
        delay: 4500,
        color: "#83adb5",
      },
      { text: "$ chmod +x hardening.sh", delay: 5200, color: "#e4e4e7" },
    ];

    sequence.forEach(({ text, delay, color }, index) => {
      setTimeout(() => {
        setLogs((prev) => [...prev, { id: Date.now() + index, text, color }]);
      }, delay);
    });
  };

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
        {/* Passing the prop here */}
        <Hero onDownloadStart={simulateDownloadLogs} />

        {/* Passing the logs here */}
        <TerminalPreview lines={logs} />

        {/* Divider */}
        <Box
          sx={{
            height: "1px",
            background:
              "linear-gradient(90deg, transparent, rgba(255,255,255,0.08), transparent)",
            mb: 8,
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
