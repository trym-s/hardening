from pathlib import Path
from pathlib import Path
from typing import List
import tempfile

from app.static.hardening_rules.src.tools import compose_rule_scripts

class ScriptService:
    def __init__(self, platform: str):
        # 1. Platform ismini kaydediyoruz (AttributeError çözümü için)
        self.platform = platform
        
        # 2. Dosya yollarını belirliyoruz
        # compose_rule_scripts.py konumu: .../src/tools/compose_rule_scripts.py
        self.tools_path = Path(compose_rule_scripts.__file__).parent.resolve()
        self.src_path = self.tools_path.parent  # .../src/ (Root path for rules)
        
        # index.json dosyasının tam yolu
        self.registry_path = self.src_path / "platforms" / platform / "rules" / "index.json"

    async def generate_custom_script(self, rule_ids: List[str]) -> str:
        """
        Generates a single bash script from selected rule IDs for the given platform.
        """
        if not self.registry_path.exists():
            raise FileNotFoundError(f"Registry file not found for platform: {self.registry_path}. Please access the rules list first.")

        with tempfile.NamedTemporaryFile(mode='w', delete=True, suffix=".sh") as tmp_file:
            output_path = Path(tmp_file.name)

            # 3. registry_root parametresini gönderiyoruz (FileNotFoundError çözümü için)
            script_content = compose_rule_scripts.compose_script(
                registry_path=self.registry_path,
                rule_ids=rule_ids,
                output_path=output_path,
                registry_root=self.src_path 
            )
        
        return script_content
