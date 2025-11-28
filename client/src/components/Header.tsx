import React from "react";
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  Box,
  Container,
  IconButton,
} from "@mui/material";
import SecurityIcon from "@mui/icons-material/Security";
import GitHubIcon from "@mui/icons-material/GitHub";
import MenuIcon from "@mui/icons-material/Menu";
// For Mobile

export const Header: React.FC = () => {
  return (
    <AppBar
      position="sticky"
      color="transparent"
      elevation={0}
      sx={{
        borderBottom: "1px solid rgba(255,255,255,0.08)",
        backdropFilter: "blur(12px)",
        backgroundColor: "rgba(9, 9, 11, 0.7)", // Zinc 950 with opacity
        zIndex: 100,
      }}
    >
      <Container maxWidth="lg">
        <Toolbar disableGutters sx={{ height: 64 }}>
          {/* Logo Area */}
          <Box sx={{ display: "flex", alignItems: "center", flexGrow: 1 }}>
            <Box
              sx={{
                mr: 2,
                p: 0.5,
                borderRadius: "8px",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                width: 32, // Adjust size as needed
                height: 32, // Adjust size as needed
              }}
            >
              <img src="/icon.jpg" alt="Hardener.ai Logo" style={{ width: '100%', height: '100%', objectFit: 'contain', borderRadius: '4px' }} />
            </Box>
            <Typography
              variant="h6"
              component="div"
              sx={{
                fontWeight: 700,
                letterSpacing: "-0.01em",
                background: "linear-gradient(to right, #fff, #a1a1aa)",
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
              }}
            >
              Hardener
              <Box component="span" sx={{ color: "primary.main" }}>
                .ai
              </Box>
            </Typography>
          </Box>

          {/* Desktop Nav */}
          <Box
            sx={{
              display: { xs: "none", md: "flex" },
              alignItems: "center",
              gap: 1,
            }}
          >
            <Button
              color="inherit"
              sx={{
                color: "text.secondary",
                "&:hover": { color: "white", bgcolor: "transparent" },
              }}
            >
              Features
            </Button>
            <Button
              color="inherit"
              sx={{
                color: "text.secondary",
                "&:hover": { color: "white", bgcolor: "transparent" },
              }}
            >
              Docs
            </Button>
            <Button
              variant="outlined"
              startIcon={<GitHubIcon />}
              href="https://github.com/your-repo"
              target="_blank"
              sx={{
                ml: 2,
                borderColor: "rgba(255,255,255,0.2)",
                color: "white",
                "&:hover": {
                  borderColor: "white",
                  bgcolor: "rgba(255,255,255,0.05)",
                },
              }}
            >
              Star on GitHub
            </Button>
          </Box>

          {/* Mobile Menu Icon */}
          <IconButton sx={{ display: { md: "none" }, color: "text.secondary" }}>
            <MenuIcon />
          </IconButton>
        </Toolbar>
      </Container>
    </AppBar>
  );
};
