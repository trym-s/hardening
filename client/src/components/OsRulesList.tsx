import React, { useState } from "react";
import {
  Box,
  Typography,
  Collapse,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  CircularProgress,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  IconButton,
} from "@mui/material";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import AddCircleOutlineIcon from "@mui/icons-material/AddCircleOutline";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import * as Types from "../types";

interface OsRulesListProps {
  selectedOs: string | null;
  selectedRuleIds: string[];
  onRuleToggle: (ruleId: string) => void;
  groupedRules: Types.GroupedRules;
  isLoading: boolean;
}

export const OsRulesList: React.FC<OsRulesListProps> = ({
  selectedOs,
  selectedRuleIds,
  onRuleToggle,
  groupedRules,
  isLoading,
}) => {
  const [expandedRuleId, setExpandedRuleId] = useState<string | null>(null);

  const handleExpand = (ruleId: string) => {
    setExpandedRuleId(expandedRuleId === ruleId ? null : ruleId);
  };

  const rulesForSelectedOs = selectedOs
    ? groupedRules[selectedOs.toLowerCase() as Types.OSType]
    : null;

  const renderContent = () => {
    if (isLoading) {
      return <CircularProgress />;
    }

    if (!selectedOs) {
      return null;
    }

    if (!rulesForSelectedOs || Object.keys(rulesForSelectedOs).length === 0) {
      return <Typography>No rules found for {selectedOs}.</Typography>;
    }

    return (
      <>
        <Typography variant="h4" gutterBottom>
          {selectedOs} Hardening Rules
        </Typography>
        {Object.entries(rulesForSelectedOs).map(([section, rules]) => (
          <Accordion
            key={section}
            defaultExpanded
            sx={{
              bgcolor: "rgba(255, 255, 255, 0.03)",
              color: "text.primary",
              mb: 1,
            }}
          >
            <AccordionSummary
              expandIcon={<ExpandMoreIcon sx={{ color: "white" }} />}
            >
              <Typography variant="h6">{section}</Typography>
            </AccordionSummary>
            <AccordionDetails sx={{ p: 0 }}>
              <List disablePadding>
                {rules.map((rule: Types.Rule) => (
                  <React.Fragment key={rule.id}>
                    <ListItem
                      sx={{
                        borderBottom: "1px solid rgba(255,255,255,0.1)",
                        "&:last-child": { borderBottom: "none" },
                      }}
                    >
                      <ListItemIcon>
                        <IconButton
                          onClick={() => onRuleToggle(rule.id)}
                          sx={{ color: "text.secondary" }}
                        >
                          {selectedRuleIds.includes(rule.id) ? (
                            <CheckCircleIcon color="primary" />
                          ) : (
                            <AddCircleOutlineIcon />
                          )}
                        </IconButton>
                      </ListItemIcon>
                      <ListItemText
                        primary={rule.title}
                        onClick={() => handleExpand(rule.id)}
                        sx={{ cursor: "pointer" }}
                      />
                    </ListItem>
                    <Collapse
                      in={expandedRuleId === rule.id}
                      timeout="auto"
                      unmountOnExit
                    >
                      <Box sx={{ p: 2, bgcolor: "rgba(0,0,0,0.2)", color: "text.secondary" }}>
                        <Typography variant="body2">
                          {rule.description || "No description available."}
                        </Typography>
                      </Box>
                    </Collapse>
                  </React.Fragment>
                ))}
              </List>
            </AccordionDetails>
          </Accordion>
        ))}
      </>
    );
  };

  return (
    <Collapse in={!!selectedOs} timeout="auto" unmountOnExit>
      <Box
        sx={{
          mt: 6,
          p: 4,
          bgcolor: "rgba(255, 255, 255, 0.02)",
          borderRadius: 3,
          border: "1px solid rgba(255,255,255,0.08)",
        }}
      >
        {renderContent()}
      </Box>
    </Collapse>
  );
};
