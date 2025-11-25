import React from "react";
import { Box, Container, Grid, Typography, Paper } from "@mui/material";
import TerminalIcon from "@mui/icons-material/Terminal";
import SpeedIcon from "@mui/icons-material/Speed";
import ShieldIcon from "@mui/icons-material/Security";
import AutoFixHighIcon from "@mui/icons-material/AutoFixHigh";

const features = [
  {
    icon: <TerminalIcon color="primary" />,
    title: "Shell Script Generation",
    description:
      "Get ready-to-run .sh files tailored for Ubuntu, CentOS, or Debian environments instantly.",
  },
  {
    icon: <AutoFixHighIcon color="secondary" />,
    title: "AI-Powered Analysis",
    description:
      "Our LLM engine analyzes current CVEs and best practices to suggest the optimal hardening strategy.",
  },
  {
    icon: <ShieldIcon sx={{ color: "#f59e0b" }} />, // Amber
    title: "CIS Benchmark Compliant",
    description:
      "Scripts typically align with CIS benchmarks levels 1 & 2 for maximum compliance.",
  },
  {
    icon: <SpeedIcon sx={{ color: "#ec4899" }} />, // Pink
    title: "Zero Latency",
    description:
      "Streaming responses ensure you get your security remediation steps in real-time.",
  },
];

export const Features: React.FC = () => {
  return (
    <Box sx={{ py: 10, bgcolor: "transparent" }}>
      <Container maxWidth="lg">
        <Typography
          variant="h2"
          textAlign="center"
          sx={{ mb: 6, fontSize: { xs: "2rem", md: "2.5rem" } }}
        >
          Built for Modern Infrastructure
        </Typography>

        <Grid container spacing={3}>
          {features.map((feature, index) => (
            <Grid item xs={12} md={6} lg={3} key={index}>
              <Paper
                variant="outlined"
                sx={{
                  p: 3,
                  height: "100%",
                  bgcolor: "rgba(255,255,255,0.02)",
                  borderColor: "rgba(255,255,255,0.08)",
                  transition: "all 0.3s ease",
                  "&:hover": {
                    transform: "translateY(-4px)",
                    borderColor: "primary.main",
                    boxShadow: "0 10px 40px -10px rgba(77, 182, 172, 0.2)",
                  },
                }}
              >
                <Box
                  sx={{
                    mb: 2,
                    width: 48,
                    height: 48,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    borderRadius: 2,
                    bgcolor: "rgba(255,255,255,0.05)",
                  }}
                >
                  {feature.icon}
                </Box>
                <Typography variant="h6" fontWeight="bold" gutterBottom>
                  {feature.title}
                </Typography>
                <Typography
                  variant="body2"
                  color="text.secondary"
                  lineHeight={1.6}
                >
                  {feature.description}
                </Typography>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
};
