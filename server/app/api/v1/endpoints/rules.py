from fastapi import APIRouter, Depends
from typing import List, Dict
from app.services.rule_service import RuleService
from app.schemas.script import RuleBase, OSType

router = APIRouter()

@router.get("/", response_model=Dict[OSType, Dict[str, List[RuleBase]]])
async def get_all_rules(service: RuleService = Depends(RuleService)):
    """
    Get all rules, grouped by OS and then by section.
    """
    rules = await service.get_registry()
    
    grouped_rules: Dict[OSType, Dict[str, List[RuleBase]]] = {}
    
    for rule_data in rules:
        rule = RuleBase(**rule_data)
        os = rule.os
        section = rule.section
        
        if os not in grouped_rules:
            grouped_rules[os] = {}
        
        if section not in grouped_rules[os]:
            grouped_rules[os][section] = []
            
        grouped_rules[os][section].append(rule)
        
    return grouped_rules
