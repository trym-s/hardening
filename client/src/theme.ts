import { createTheme, alpha } from "@mui/material/styles";

// Modern "Zinc" based palette with Electric Blue accent
const theme = createTheme({
  palette: {
    mode: "dark",
    primary: {
      main: "#4db6ac", // Muted Teal
      light: "#82e9de",
      dark: "#00867d",
      contrastText: "#fff",
    },
    secondary: {
      main: "#10b981", // Emerald Green
    },
    background: {
      default: "#09090b", // Zinc 950
      paper: "#18181b", // Zinc 900
    },
    text: {
      primary: "#f4f4f5", // Zinc 100
      secondary: "#a1a1aa", // Zinc 400
    },
  },
  typography: {
    fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, sans-serif',
    h1: { fontWeight: 800, letterSpacing: "-0.02em" },
    h2: { fontWeight: 700, letterSpacing: "-0.01em" },
    button: { fontWeight: 600, textTransform: "none" }, // No uppercase buttons
  },
  shape: {
    borderRadius: 12,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: "8px",
          padding: "8px 20px",
          boxShadow: "none",
          "&:hover": {
            boxShadow: "0 4px 12px rgba(77, 182, 172, 0.4)", // Teal glow on hover
          },
        },
        containedPrimary: {
          background: "linear-gradient(135deg, #4db6ac 0%, #00867d 100%)",
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: "none",
          border: `1px solid ${alpha("#fff", 0.08)}`,
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          "& .MuiOutlinedInput-root": {
            "& fieldset": {
              borderColor: alpha("#fff", 0.15),
            },
            "&:hover fieldset": {
              borderColor: alpha("#fff", 0.3),
            },
          },
        },
      },
    },
  },
});

export default theme;
