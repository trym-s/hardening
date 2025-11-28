import React, { useState, useEffect } from "react";
import { Box, Container, Typography, Grid, Paper, Button } from "@mui/material";
import { Header } from "../components/Header";
import { ChatWidget } from "../components/ChatWidget";
import { OsRulesList } from "../components/OsRulesList";
import { GenerateScriptModal } from "../components/GenerateScriptModal";
import { AnimatePresence, motion } from "framer-motion";
import { scriptService, rulesService } from "../services";
import * as Types from "../types";
// Mock OS data
const operatingSystems = [
  { name: "Ubuntu", version: "22.04 LTS", icon: "ubuntu" },
  { name: "Debian", version: "12", icon: "debian" },
  { name: "CentOS", version: "Stream 9", icon: "centos" },
  { name: "Fedora", version: "40", icon: "fedora" },
  { name: "Windows", version: "10/11", icon: "windows" },
];

const MotionFab = motion.div;

// A simple component to render an OS-like icon
const OSListItemIcon = ({ icon }: { icon: string }) => {
  const iconUrl = `/os_icons/${icon}.png`;
  const ubuntuIconUrl = `/os_icons/ubuntu`;

  // Handle ubuntu icon not having an extension
  const finalIconUrl = icon === "ubuntu" ? ubuntuIconUrl : iconUrl;

  return (
    <Box
      sx={{
        width: 40,
        height: 40,
        mr: 2,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <img
        src={finalIconUrl}
        alt={`${icon} logo`}
        style={{ width: "100%", height: "100%", objectFit: "contain" }}
        onError={(e) => {
          // Fallback to a placeholder if the image fails to load
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
  const [selectedOs, setSelectedOs] = useState<string | null>(null);
  const [selectedRuleIds, setSelectedRuleIds] = useState<string[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [scriptContent, setScriptContent] = useState<string | null>(null);
  const [scriptName, setScriptName] = useState<string>("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [groupedRules, setGroupedRules] = useState<Types.GroupedRules>({});
  const [isRulesLoading, setIsRulesLoading] = useState<boolean>(true);

  useEffect(() => {
    const fetchRules = async () => {
      try {
        setIsRulesLoading(true);
        const rules = await rulesService.getGroupedRules();
        setGroupedRules(rules);
      } catch (error) {
        console.error("Failed to fetch rules:", error);
      } finally {
        setIsRulesLoading(false);
      }
    };

    fetchRules();
  }, []);

  const handleOsSelect = (osName: string) => {
    setSelectedOs((prev) => (prev === osName ? null : osName));
    setSelectedRuleIds([]); // Clear selected rules when OS changes
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
        rule_ids: selectedRuleIds,
        os_type: selectedOs.toLowerCase() as Types.OSType,
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
    const rulesForOs = groupedRules[selectedOs.toLowerCase() as Types.OSType];
    if (!rulesForOs) return [];

    const allRules = Object.values(rulesForOs).flat();
    return allRules.filter((rule) => selectedRuleIds.includes(rule.id));
  };

  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        minHeight: "100vh",
        position: "relative",
        bgcolor: "background.default",
      }}
    >
      <Header />

      <Container maxWidth="lg" sx={{ py: 8, flexGrow: 1 }}>
        <Typography
          variant="h2"
          component="h1"
          gutterBottom
          textAlign="center"
          sx={{ fontWeight: 700 }}
        >
          Select Your Operating System
        </Typography>
        <Typography
          variant="h6"
          color="text.secondary"
          textAlign="center"
          sx={{ mb: 8 }}
        >
          Choose your OS to get a tailor-made hardening script.
        </Typography>

        <Grid container spacing={4}>
          {operatingSystems.map((os) => (
            <Grid item xs={12} sm={6} md={4} key={os.name}>
              {(() => {
                const isUbuntu = os.name === "Ubuntu";
                return (
                  <Paper
                    elevation={0}
                    onClick={
                      isUbuntu ? () => handleOsSelect(os.name) : undefined
                    }
                    sx={{
                      p: 3,
                      display: "flex",
                      alignItems: "center",
                      borderRadius: 3,
                      bgcolor: "rgba(255, 255, 255, 0.03)",
                      border: "1px solid",
                      borderColor:
                        selectedOs === os.name
                          ? "primary.main"
                          : "rgba(255,255,255,0.08)",
                      transition:
                        "transform 0.2s, box-shadow 0.2s, border-color 0.2s, opacity 0.2s",
                      cursor: isUbuntu ? "pointer" : "not-allowed",
                      opacity: isUbuntu ? 1 : 0.4,
                      "&:hover": {
                        transform: isUbuntu ? "translateY(-5px)" : "none",
                        boxShadow: isUbuntu
                          ? "0 10px 20px rgba(0,0,0,0.2)"
                          : "none",
                        borderColor:
                          selectedOs === os.name
                            ? "primary.dark"
                            : isUbuntu
                              ? "rgba(255, 255, 255, 0.2)"
                              : "rgba(255,255,255,0.08)",
                      },
                    }}
                  >
                    <OSListItemIcon icon={os.icon} />
                    <Box>
                      <Typography
                        variant="h6"
                        component="div"
                        sx={{ fontWeight: 600 }}
                      >
                        {os.name}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        {os.version}
                      </Typography>
                    </Box>
                  </Paper>
                );
              })()}
            </Grid>
          ))}
        </Grid>

        <OsRulesList
          selectedOs={selectedOs}
          selectedRuleIds={selectedRuleIds}
          onRuleToggle={handleRuleToggle}
          groupedRules={groupedRules}
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
            style={{
              position: "fixed",
              bottom: 32,
              left: "50%",
              transform: "translateX(-50%)",
              zIndex: 1000,
            }}
          >
            <Button
              variant="contained"
              color="primary"
              size="large"
              onClick={handleGenerateScript}
              sx={{
                boxShadow: "0 4px 20px rgba(77, 182, 172, 0.5)",
                borderRadius: "50px",
                padding: "12px 24px",
                fontWeight: 600,
              }}
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

      {/* Footer */}
      <Box
        component="footer"
        sx={{
          py: 6,
          textAlign: "center",
          borderTop: "1px solid rgba(255,255,255,0.05)",
          bgcolor: "#09090b",
        }}
      >
        <Typography variant="body2" color="text.secondary">
          © 2025 System Hardening. Open Source Security.
        </Typography>
      </Box>
    </Box>
  );
};

