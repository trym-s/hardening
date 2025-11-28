import React from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Box,
  Typography,
  CircularProgress,
  IconButton,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
} from "@mui/material";
import CloseIcon from "@mui/icons-material/Close";
import FileDownloadIcon from "@mui/icons-material/FileDownload";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import * as Types from "../types";

interface GenerateScriptModalProps {
  open: boolean;
  onClose: () => void;
  isLoading: boolean;
  scriptContent: string | null;
  scriptName: string;
  selectedRules: Types.Rule[];
}

export const GenerateScriptModal: React.FC<GenerateScriptModalProps> = ({
  open,
  onClose,
  isLoading,
  scriptContent,
  scriptName,
  selectedRules,
}) => {
  const handleDownload = () => {
    if (!scriptContent) return;
    const blob = new Blob([scriptContent], { type: "text/x-shellscript" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = scriptName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      fullWidth
      maxWidth="sm"
      PaperProps={{
        sx: {
          bgcolor: "background.paper",
          border: "1px solid rgba(255,255,255,0.1)",
        },
      }}
    >
      <DialogTitle
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        Generate Hardening Script
        <IconButton onClick={onClose}>
          <CloseIcon />
        </IconButton>
      </DialogTitle>
      <DialogContent dividers>
        {isLoading ? (
          <Box
            sx={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              height: 200,
            }}
          >
            <CircularProgress />
            <Typography sx={{ ml: 2 }}>Generating your script...</Typography>
          </Box>
        ) : (
          <Box>
            <Typography variant="h6" gutterBottom>
              Script ready for download!
            </Typography>
            <Typography variant="body1" color="text.secondary" sx={{ mb: 2 }}>
              The following {selectedRules.length} rules will be included in
              your custom script:
            </Typography>
            <Box
              sx={{
                maxHeight: "40vh",
                overflow: "auto",
                bgcolor: "rgba(0,0,0,0.2)",
                p: 1,
                borderRadius: 1,
              }}
            >
              <List dense>
                {selectedRules.map((rule) => (
                  <ListItem key={rule.id}>
                    <ListItemIcon sx={{ minWidth: 32 }}>
                      <CheckCircleIcon color="success" fontSize="small" />
                    </ListItemIcon>
                    <ListItemText primary={rule.title} />
                  </ListItem>
                ))}
              </List>
            </Box>
          </Box>
        )}
      </DialogContent>
      <DialogActions sx={{ p: 2 }}>
        <Button
          onClick={handleDownload}
          disabled={isLoading || !scriptContent}
          variant="contained"
          startIcon={<FileDownloadIcon />}
          size="large"
        >
          Download Script
        </Button>
      </DialogActions>
    </Dialog>
  );
};

