from pydantic import BaseModel

class ReportInput(BaseModel):
    data: dict
