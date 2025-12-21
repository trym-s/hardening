import json
from pathlib import Path
from typing import List

from app.static.hardening_rules.src import build_registry

class RuleService:
    def __init__(self, platform: str):
        # Calculate the path to the 'platforms' directory relative to RuleService.py
        # Path(__file__) is server/app/services/rule_service.py
        # .parent is server/app/services/
        # .parent.parent is server/app/
        # .parent.parent.parent is server/
        # This will resolve to the project root, then append the rest of the path
        self.platforms_base_dir = Path(__file__).parent.parent.parent.parent / "server" / "app" / "static" / "hardening_rules" / "src" / "platforms"
        self.platform_path = self.platforms_base_dir / platform
        self.rules_dir = self.platform_path / "rules"
        self.registry_path = self.rules_dir / "index.json"

        print(f"DEBUG RuleService: Received platform: {platform}")
        print(f"DEBUG RuleService: Constructed platforms_base_dir: {self.platforms_base_dir}")
        print(f"DEBUG RuleService: Constructed platform_path: {self.platform_path}")
        print(f"DEBUG RuleService: Constructed rules_dir: {self.rules_dir}")
        print(f"DEBUG RuleService: Constructed registry_path: {self.registry_path}")

    async def get_registry(self) -> List[dict]:
        """
        Reads the index.json for the specified platform. Creates it if it doesn't exist.
        """
        print(f"DEBUG RuleService: Checking if registry_path exists: {self.registry_path.exists()}")
        if not self.registry_path.exists():
            print(f"DEBUG RuleService: Registry for platform '{self.platform_path.name}' not found, generating...")
            build_registry.process_platform(self.platform_path)
            print(f"DEBUG RuleService: After generation, registry_path exists: {self.registry_path.exists()}")

        if not self.registry_path.exists():
            raise FileNotFoundError(f"Registry could not be created for platform: {self.platform_path}")

        with open(self.registry_path, "r", encoding="utf-8") as f:
            return json.load(f)
