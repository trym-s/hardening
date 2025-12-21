import React, { useState, useEffect } from "react";
import { Box, Container, Typography, Grid, Paper, Button } from "@mui/material";
import { Header } from "../components/Header";
import { ChatWidget } from "../components/ChatWidget";
import { OsRulesList } from "../components/OsRulesList";
import { GenerateScriptModal } from "../components/GenerateScriptModal";
import { AnimatePresence, motion } from "framer-motion";
import { scriptService, rulesService } from "../services";
import * as Types from "../types";

// Updated OS data with platform strings for the API
const operatingSystems: {
  name: string;
  version: string;
  icon: string;
  platform: string;
  enabled: boolean;
}[] = [
  { name: "Ubuntu Desktop", version: "22.04 LTS", icon: "ubuntu", platform: "linux/ubuntu/desktop", enabled: true },
  { name: "Debian", version: "12", icon: "debian", platform: "linux/debian/12", enabled: false },
  { name: "CentOS", version: "Stream 9", icon: "centos", platform: "linux/centos/9", enabled: false },
  { name: "Fedora", version: "40", icon: "fedora", platform: "linux/fedora/40", enabled: false },
  { name: "Windows 11", version: "Desktop", icon: "windows", platform: "windows/desktop/win11", enabled: false },
  { name: "Windows Server", version: "2022", icon: "windows", platform: "windows/server/2022", enabled: false },
];

const MotionFab = motion.div;

// A simple component to render an OS-like icon
const OSListItemIcon = ({ icon }: { icon: string }) => {
  const iconUrl = `/os_icons/${icon}.png`;
  // Special case for ubuntu icon which is a direct file path without extension for some reason
  const finalIconUrl = icon === "ubuntu" ? "/os_icons/ubuntu" : iconUrl;

  return (
    <Box sx={{ width: 40, height: 40, mr: 2, display: "flex", alignItems: "center", justifyContent: "center" }}>
      <img
        src={finalIconUrl}
        alt={`${icon} logo`}
        style={{ width: "100%", height: "100%", objectFit: "contain" }}
        onError={(e) => {
          e.currentTarget.style.display = "none";
          const placeholder = document.createElement("div");
          placeholder.style.width = "40px";
          placeholder.style.height = "40px";
          placeholder.style.borderRadius = "4px";
          placeholder.style.backgroundColor = "#888";
          e.currentTarget.parentElement?.appendChild(placeholder);
        }}
      />
    </Box>
  );
};

export const OsSelectionPage: React.FC = () => {
  const [selectedOs, setSelectedOs] = useState<(typeof operatingSystems)[0] | null>(null);
  const [selectedRuleIds, setSelectedRuleIds] = useState<string[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [scriptContent, setScriptContent] = useState<string | null>(null);
  const [scriptName, setScriptName] = useState<string>("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [platformRules, setPlatformRules] = useState<Types.PlatformRules>({});
  const [isRulesLoading, setIsRulesLoading] = useState<boolean>(false);

  const handleOsSelect = async (os: (typeof operatingSystems)[0]) => {
    if (selectedOs?.platform === os.platform) {
      setSelectedOs(null);
      setPlatformRules({});
      setSelectedRuleIds([]);
      return;
    }

    setSelectedOs(os);
    setSelectedRuleIds([]);
    try {
      setIsRulesLoading(true);
      const rules = await rulesService.getRulesForPlatform(os.platform);
      setPlatformRules(rules);
    } catch (error) {
      console.error(`Failed to fetch rules for ${os.platform}:`, error);
      setPlatformRules({}); // Clear rules on error
    } finally {
      setIsRulesLoading(false);
    }
  };

  const handleRuleToggle = (ruleId: string) => {
    setSelectedRuleIds((prevSelected) => {
      if (prevSelected.includes(ruleId)) {
        return prevSelected.filter((id) => id !== ruleId);
      } else {
        return [...prevSelected, ruleId];
      }
    });
  };

  const handleGenerateScript = async () => {
    if (selectedRuleIds.length === 0 || !selectedOs) return;

    setIsModalOpen(true);
    setIsGenerating(true);
    setScriptContent(null);

    try {
      const response = await scriptService.generateCustomScript({
        platform: selectedOs.platform,
        rule_ids: selectedRuleIds,
      });
      setScriptContent(response.content);
      setScriptName(response.filename);
    } catch (error) {
      console.error("Failed to generate script:", error);
      setScriptContent("# An error occurred while generating the script.");
      setScriptName("error.sh");
    } finally {
      setIsGenerating(false);
    }
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const getSelectedRules = (): Types.Rule[] => {
    if (!selectedOs) return [];
    const allRules = Object.values(platformRules).flat();
    return allRules.filter((rule) => selectedRuleIds.includes(rule.id));
  };

  return (
    <Box sx={{ display: "flex", flexDirection: "column", minHeight: "100vh", position: "relative", bgcolor: "background.default" }}>
      <Header />

      <Container maxWidth="lg" sx={{ py: 8, flexGrow: 1 }}>
        <Typography variant="h2" component="h1" gutterBottom textAlign="center" sx={{ fontWeight: 700 }}>
          Select Your Operating System
        </Typography>
        <Typography variant="h6" color="text.secondary" textAlign="center" sx={{ mb: 8 }}>
          Choose your OS to get a tailor-made hardening script.
        </Typography>

        <Grid container spacing={4}>
          {operatingSystems.map((os) => (
            <Grid item xs={12} sm={6} md={4} key={os.platform}>
              <Paper
                elevation={0}
                onClick={os.enabled ? () => handleOsSelect(os) : undefined}
                sx={{
                  p: 3,
                  display: "flex",
                  alignItems: "center",
                  borderRadius: 3,
                  bgcolor: "rgba(255, 255, 255, 0.03)",
                  border: "1px solid",
                  borderColor: selectedOs?.platform === os.platform ? "primary.main" : "rgba(255,255,255,0.08)",
                  transition: "transform 0.2s, box-shadow 0.2s, border-color 0.2s, opacity 0.2s",
                  cursor: os.enabled ? "pointer" : "not-allowed",
                  opacity: os.enabled ? 1 : 0.4,
                  "&:hover": {
                    transform: os.enabled ? "translateY(-5px)" : "none",
                    boxShadow: os.enabled ? "0 10px 20px rgba(0,0,0,0.2)" : "none",
                    borderColor: selectedOs?.platform === os.platform ? "primary.dark" : os.enabled ? "rgba(255, 255, 255, 0.2)" : "rgba(255,255,255,0.08)",
                  },
                }}
              >
                <OSListItemIcon icon={os.icon} />
                <Box>
                  <Typography variant="h6" component="div" sx={{ fontWeight: 600 }}>
                    {os.name}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {os.version}
                  </Typography>
                </Box>
              </Paper>
            </Grid>
          ))}
        </Grid>

        <OsRulesList
          selectedOsName={selectedOs?.name}
          platformRules={platformRules}
          selectedRuleIds={selectedRuleIds}
          onRuleToggle={handleRuleToggle}
          isLoading={isRulesLoading}
        />
      </Container>

      <AnimatePresence>
        {selectedRuleIds.length > 0 && (
          <MotionFab
            initial={{ y: 100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 100, opacity: 0 }}
            transition={{ type: "spring", stiffness: 260, damping: 20 }}
            style={{ position: "fixed", bottom: 32, left: "50%", transform: "translateX(-50%)", zIndex: 1000 }}
          >
            <Button
              variant="contained"
              color="primary"
              size="large"
              onClick={handleGenerateScript}
              sx={{ boxShadow: "0 4px 20px rgba(77, 182, 172, 0.5)", borderRadius: "50px", padding: "12px 24px", fontWeight: 600 }}
            >
              Generate Script ({selectedRuleIds.length} selected)
            </Button>
          </MotionFab>
        )}
      </AnimatePresence>

      <ChatWidget />

      <GenerateScriptModal
        open={isModalOpen}
        onClose={handleCloseModal}
        isLoading={isGenerating}
        scriptContent={scriptContent}
        scriptName={scriptName}
        selectedRules={getSelectedRules()}
      />

      <Box component="footer" sx={{ py: 6, textAlign: "center", borderTop: "1px solid rgba(255,255,255,0.05)", bgcolor: "#09090b" }}>
        <Typography variant="body2" color="text.secondary">
          © 2025 System Hardening. Open Source Security.
        </Typography>
      </Box>
    </Box>
  );
};

