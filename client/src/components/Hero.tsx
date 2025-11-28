import React from "react";
import {
  Box,
  Typography,
  Button,
  Container,
  Chip,
} from "@mui/material";
import SecurityIcon from "@mui/icons-material/Security";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';

export const Hero: React.FC = () => {
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
            component={Link}
            to="/os"
            variant="contained"
            color="primary"
            size="large"
            endIcon={<ArrowForwardIcon />}
            sx={{ px: 4, py: 1.5, fontSize: "1rem" }}
          >
            Select Your OS
          </Button>
        </Box>
      </motion.div>
    </Container>
  );
};
