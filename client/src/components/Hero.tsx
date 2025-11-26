import React, { useState } from "react";
import {
  Box,
  Typography,
  Button,
  Container,
  CircularProgress,
  Chip,
} from "@mui/material";
import DownloadIcon from "@mui/icons-material/DownloadRounded";
import SecurityIcon from "@mui/icons-material/Security";
import { scriptService } from "../services";
import { saveAs } from "file-saver";
import { motion } from "framer-motion";

// New: Prop definition for communicating with the Parent component (HomePage)
interface HeroProps {
  onDownloadStart?: () => void;
}

export const Hero: React.FC<HeroProps> = ({ onDownloadStart }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleDownload = async () => {
    setIsLoading(true);
    setError(null);

    // Trigger terminal animation
    if (onDownloadStart) {
      onDownloadStart();
    }

    try {
      const scriptContent = await scriptService.downloadScript();
      const blob = new Blob([scriptContent], {
        type: "text/x-shellscript;charset=utf-8",
      });
      saveAs(blob, "hardening.sh");
    } catch (_err) {
      setError("Failed to download script. Please try again later.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Container
      maxWidth="md"
      sx={{ textAlign: "center", py: 16, position: "relative", zIndex: 1 }}
    >
      {/* Background Glow */}
      <Box
        sx={{
          position: "absolute",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          width: "600px",
          height: "600px",
          background:
            "radial-gradient(circle, rgba(77, 182, 172, 0.12) 0%, rgba(9, 9, 11, 0) 70%)",
          zIndex: -1,
          filter: "blur(60px)",
          pointerEvents: "none",
        }}
      />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8 }}
      >
        <Chip
          label="v1.0-beta Now Available"
          icon={<SecurityIcon sx={{ fontSize: 16 }} />}
          sx={{
            mb: 3,
            bgcolor: "rgba(77, 182, 172, 0.1)",
            color: "primary.light",
            border: "1px solid rgba(77, 182, 172, 0.2)",
            fontWeight: 500,
          }}
        />

        <Typography
          variant="h1"
          component="h1"
          sx={{
            mb: 2,
            fontSize: { xs: "3rem", md: "5rem" },
            background:
              "linear-gradient(to bottom right, #ffffff 30%, #94a3b8 100%)",
            WebkitBackgroundClip: "text",
            WebkitTextFillColor: "transparent",
            letterSpacing: "-0.03em",
            lineHeight: 1.1,
          }}
        >
          Automate System <br /> Hardening
        </Typography>

        <Typography
          variant="h5"
          color="text.secondary"
          sx={{
            mb: 6,
            maxWidth: "600px",
            mx: "auto",
            lineHeight: 1.6,
            fontWeight: 300,
          }}
        >
          Instantly generate compliance-ready shell scripts to secure your Linux
          infrastructure. Powered by AI, designed for DevOps.
        </Typography>

        <Box sx={{ display: "flex", gap: 2, justifyContent: "center" }}>
          <Button
            variant="contained"
            color="primary"
            size="large"
            startIcon={
              isLoading ? (
                <CircularProgress size={20} color="inherit" />
              ) : (
                <DownloadIcon />
              )
            }
            onClick={handleDownload}
            disabled={isLoading}
            sx={{ px: 4, py: 1.5, fontSize: "1rem" }}
          >
            {isLoading ? "Downloading..." : "Download Script"}
          </Button>
          <Button
            variant="outlined"
            size="large"
            color="inherit"
            href="https://github.com/your-repo"
            target="_blank"
            sx={{
              px: 4,
              py: 1.5,
              fontSize: "1rem",
              borderColor: "rgba(255,255,255,0.1)",
              color: "text.primary",
            }}
          >
            Documentation
          </Button>
        </Box>

        {error && (
          <Typography color="error" sx={{ mt: 3 }}>
            {error}
          </Typography>
        )}
      </motion.div>
    </Container>
  );
};
