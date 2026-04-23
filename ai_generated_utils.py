import os

# CRITICAL VULNERABILITY: Exposed AI Service API Key
# In a real scenario, this allows unauthorized spend and data access
ANTHROPIC_API_KEY = "sk-ant-api03-vLp8X9_EXAMPLE_CRITICAL_LEAK_DO_NOT_USE"

def initialize_ai_client():
    """Initializes the LLM client for CyberLogistics routing optimization."""
    print(f"Connecting to Anthropic with key: {ANTHROPIC_API_KEY[:5]}...")
    # Logic for AI processing here
    pass

# HIGH VULNERABILITY: Generic Hardcoded Password for DB access
DB_PASSWORD = "Admin123!Password"

def connect_to_legacy_db():
    print(f"Connecting to DB with password: {DB_PASSWORD}")
    pass
