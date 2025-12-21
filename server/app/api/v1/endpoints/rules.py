from app.api.v1.endpoints import chat, report, script, rules
from fastapi import APIRouter, Depends, Query
from typing import List, Dict
from app.services.rule_service import RuleService
from app.schemas.script import RuleBase
from app.api.deps import get_rule_service, get_platform

router = APIRouter()

@router.get("/", response_model=Dict[str, List[RuleBase]])
async def get_all_rules(
    platform: str = Depends(get_platform),
    service: RuleService = Depends(get_rule_service)
):
    """
    Get all rules for a specific platform, grouped by section.
    Requires a 'platform' query parameter.
    """
    rules = await service.get_registry()
    
    grouped_rules: Dict[str, List[RuleBase]] = {}
    
    for rule_data in rules:
        rule = RuleBase(**rule_data)
        section = rule.section
        
        if section not in grouped_rules:
            grouped_rules[section] = []
            
        grouped_rules[section].append(rule)
        
    return grouped_rules
