from pathlib import Path
from typing import List
import tempfile

from app.static.hardening_rules.src.tools import build_registry, compose_rule_scripts

class ScriptService:
    def __init__(self):
        self.registry_path = build_registry.DEFAULT_OUTPUT_PATH

    async def generate_custom_script(self, rule_ids: List[str]) -> str:
        """
        Generates a single bash script from selected rule IDs.
        """
        with tempfile.NamedTemporaryFile(mode='w', delete=True, suffix=".sh") as tmp_file:
            output_path = Path(tmp_file.name)

            script_content = compose_rule_scripts.compose_script(
                registry_path=self.registry_path,
                rule_ids=rule_ids,
                output_path=output_path
            )
        
        return script_content