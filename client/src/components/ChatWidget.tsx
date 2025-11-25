import React, { useState, useRef, useEffect } from "react";
import {
  Box,
  Typography,
  TextField,
  IconButton,
  Paper,
  Avatar,
  Tooltip,
  CircularProgress,
} from "@mui/material";
import ChatIcon from "@mui/icons-material/ChatBubbleOutline";
import SendIcon from "@mui/icons-material/SendRounded";
import SmartToyIcon from "@mui/icons-material/SmartToy";
import OpenInFullIcon from "@mui/icons-material/OpenInFull";
import CloseFullscreenIcon from "@mui/icons-material/CloseFullscreen";
import RemoveIcon from "@mui/icons-material/Remove";
import { chatService } from "../services";
import { AnimatePresence, motion } from "framer-motion";

// Create motion components
const MotionPaper = motion(Paper);
const MotionFab = motion.div;

interface Message {
  sender: "user" | "bot";
  text: string;
}

export const ChatWidget: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  const [messages, setMessages] = useState<Message[]>([
    {
      sender: "bot",
      text: "Hello! I am your AI security assistant. Ask me anything about system hardening.",
    },
  ]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  // Resizing State
  const [size, setSize] = useState({ width: 380, height: 500 });
  const isResizing = useRef(false);

  const messagesEndRef = useRef<null | HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(scrollToBottom, [messages, isOpen]);

  // Resize Logic (Top-Left corner drag)
  const startResize = (e: React.MouseEvent) => {
    e.preventDefault();
    isResizing.current = true;
    document.addEventListener("mousemove", handleResize);
    document.addEventListener("mouseup", stopResize);
  };

  const handleResize = (e: MouseEvent) => {
    if (!isResizing.current) return;
    // Calculate new size based on distance from bottom-right of viewport
    const newWidth = window.innerWidth - e.clientX - 32; // 32 is right margin
    const newHeight = window.innerHeight - e.clientY - 32; // 32 is bottom margin

    setSize({
      width: Math.max(300, Math.min(newWidth, 800)),
      height: Math.max(400, Math.min(newHeight, window.innerHeight - 100)),
    });
  };

  const stopResize = () => {
    isResizing.current = false;
    document.removeEventListener("mousemove", handleResize);
    document.removeEventListener("mouseup", stopResize);
  };

  const handleSend = async () => {
    if (!input.trim()) return;

    const userMessage: Message = { sender: "user", text: input };
    setMessages((prev) => [...prev, userMessage]);
    setInput("");
    setIsLoading(true);

    try {
      const stream = await chatService.streamChatResponse({ message: input });
      if (stream) {
        const reader = stream.getReader();
        const decoder = new TextDecoder();
        let botMessage = "";
        setMessages((prev) => [...prev, { sender: "bot", text: "" }]);

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          const chunk = decoder.decode(value, { stream: true });
          botMessage += chunk;
          setMessages((prev) => {
            const newMessages = [...prev];
            newMessages[newMessages.length - 1] = {
              sender: "bot",
              text: botMessage,
            };
            return newMessages;
          });
        }
      }
    } catch (error) {
      console.error(error);
      setMessages((prev) => [
        ...prev,
        { sender: "bot", text: "Connection failed." },
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  // Dynamic dimensions based on mode
  const currentWidth = isExpanded ? "600px" : `${size.width}px`;
  const currentHeight = isExpanded ? "80vh" : `${size.height}px`;

  return (
    <>
      <AnimatePresence>
        {!isOpen && (
          <MotionFab
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            transition={{ type: "spring", stiffness: 260, damping: 20 }}
            style={{ position: "fixed", bottom: 32, right: 32, zIndex: 1000 }}
          >
            <IconButton
              onClick={() => setIsOpen(true)}
              sx={{
                width: 60,
                height: 60,
                bgcolor: "primary.main",
                color: "white",
                boxShadow: "0 4px 20px rgba(77, 182, 172, 0.5)",
                "&:hover": {
                  bgcolor: "primary.dark",
                  transform: "scale(1.05)",
                },
                transition: "all 0.2s",
              }}
            >
              <ChatIcon />
            </IconButton>
          </MotionFab>
        )}
      </AnimatePresence>

      <AnimatePresence>
        {isOpen && (
          <MotionPaper
            initial={{ opacity: 0, y: 50, scale: 0.9 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 50, scale: 0.9 }}
            transition={{ type: "spring", stiffness: 300, damping: 30 }}
            elevation={24}
            sx={{
              position: "fixed",
              bottom: 32,
              right: 32,
              width: currentWidth,
              height: currentHeight,
              zIndex: 1000,
              display: "flex",
              flexDirection: "column",
              bgcolor: "rgba(24, 24, 27, 0.85)", // Zinc 900 semi-transparent
              backdropFilter: "blur(12px)",
              border: "1px solid rgba(255,255,255,0.1)",
              borderRadius: 3,
              overflow: "hidden",
            }}
          >
            {/* Header */}
            <Box
              sx={{
                p: 2,
                borderBottom: "1px solid rgba(255,255,255,0.1)",
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                bgcolor: "rgba(255,255,255,0.02)",
              }}
            >
              <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                <Avatar sx={{ bgcolor: "primary.main", width: 32, height: 32 }}>
                  <SmartToyIcon sx={{ fontSize: 18 }} />
                </Avatar>
                <Box>
                  <Typography
                    variant="subtitle2"
                    fontWeight="700"
                    lineHeight={1.2}
                  >
                    AI Assistant
                  </Typography>
                  <Typography
                    variant="caption"
                    color="success.main"
                    sx={{ display: "flex", alignItems: "center", gap: 0.5 }}
                  >
                    <Box
                      component="span"
                      sx={{
                        width: 6,
                        height: 6,
                        borderRadius: "50%",
                        bgcolor: "success.main",
                      }}
                    />
                    Online
                  </Typography>
                </Box>
              </Box>
              <Box>
                <Tooltip title={isExpanded ? "Collapse" : "Expand"}>
                  <IconButton
                    size="small"
                    onClick={() => setIsExpanded(!isExpanded)}
                    sx={{ color: "text.secondary" }}
                  >
                    {isExpanded ? (
                      <CloseFullscreenIcon fontSize="small" />
                    ) : (
                      <OpenInFullIcon fontSize="small" />
                    )}
                  </IconButton>
                </Tooltip>
                <Tooltip title="Minimize">
                  <IconButton
                    size="small"
                    onClick={() => setIsOpen(false)}
                    sx={{ color: "text.secondary", ml: 0.5 }}
                  >
                    <RemoveIcon fontSize="small" />
                  </IconButton>
                </Tooltip>
              </Box>
            </Box>

            {/* Resize Handle (Top-Left) - Only visible when not expanded */}
            {!isExpanded && (
              <Box
                onMouseDown={startResize}
                sx={{
                  position: "absolute",
                  top: 0,
                  left: 0,
                  width: 20,
                  height: 20,
                  cursor: "nwse-resize",
                  zIndex: 20,
                  "&::before": {
                    content: '""',
                    position: "absolute",
                    top: 6,
                    left: 6,
                    width: 8,
                    height: 8,
                    borderTop: "2px solid rgba(255,255,255,0.3)",
                    borderLeft: "2px solid rgba(255,255,255,0.3)",
                    borderRadius: "2px 0 0 0",
                  },
                }}
              />
            )}

            {/* Messages */}
            <Box
              sx={{
                flexGrow: 1,
                p: 2,
                overflowY: "auto",
                display: "flex",
                flexDirection: "column",
                gap: 2,
              }}
            >
              {messages.map((msg, index) => (
                <Box
                  key={index}
                  sx={{
                    alignSelf:
                      msg.sender === "user" ? "flex-end" : "flex-start",
                    maxWidth: "85%",
                  }}
                >
                  <Paper
                    sx={{
                      p: 1.5,
                      bgcolor:
                        msg.sender === "user"
                          ? "primary.main"
                          : "rgba(255,255,255,0.05)",
                      color: msg.sender === "user" ? "#fff" : "text.primary",
                      borderRadius: 2,
                      borderBottomRightRadius: msg.sender === "user" ? 4 : 12,
                      borderBottomLeftRadius: msg.sender === "bot" ? 4 : 12,
                      boxShadow: "none",
                    }}
                  >
                    <Typography variant="body2" sx={{ whiteSpace: "pre-wrap" }}>
                      {msg.text}
                    </Typography>
                  </Paper>
                </Box>
              ))}
              {isLoading && (
                <Box
                  sx={{
                    alignSelf: "flex-start",
                    display: "flex",
                    alignItems: "center",
                    gap: 1,
                    ml: 1,
                  }}
                >
                  <CircularProgress
                    size={14}
                    color="inherit"
                    sx={{ color: "text.secondary" }}
                  />
                  <Typography variant="caption" color="text.secondary">
                    Thinking...
                  </Typography>
                </Box>
              )}
              <div ref={messagesEndRef} />
            </Box>

            {/* Input */}
            <Box
              sx={{
                p: 2,
                bgcolor: "rgba(0,0,0,0.2)",
                borderTop: "1px solid rgba(255,255,255,0.1)",
              }}
            >
              <TextField
                fullWidth
                placeholder="Type a message..."
                size="small"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyPress={(e) => e.key === "Enter" && handleSend()}
                disabled={isLoading}
                sx={{
                  "& .MuiOutlinedInput-root": {
                    bgcolor: "rgba(255,255,255,0.05)",
                    borderRadius: 1.5,
                    "& fieldset": { border: "none" },
                    "&.Mui-focused": { bgcolor: "rgba(255,255,255,0.08)" },
                  },
                }}
                InputProps={{
                  endAdornment: (
                    <IconButton
                      size="small"
                      onClick={handleSend}
                      disabled={!input.trim() || isLoading}
                      color="primary"
                    >
                      <SendIcon fontSize="small" />
                    </IconButton>
                  ),
                }}
              />
            </Box>
          </MotionPaper>
        )}
      </AnimatePresence>
    </>
  );
};
