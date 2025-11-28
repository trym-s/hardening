import json
from pathlib import Path
from typing import List

from app.static.hardening_rules.src.tools import build_registry

class RuleService:
    def __init__(self):
        self.registry_path = build_registry.DEFAULT_OUTPUT_PATH
        self.rules_dir = build_registry.DEFAULT_RULES_DIR

    async def get_registry(self) -> List[dict]:
        """
        Reads rules/index.json. Creates it if it doesn't exist.
        """
        if not self.registry_path.exists():
            print("Registry not found, generating...")
            base_dir = self.registry_path.parent
            registry_entries = build_registry.discover_rules(self.rules_dir, base_dir)
            build_registry.write_registry(registry_entries, self.registry_path)
        
        with open(self.registry_path, "r", encoding="utf-8") as f:
            return json.load(f)
