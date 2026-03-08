# chat_api.py
from fastapi import FastAPI
from pydantic import BaseModel
from query_data import query_db   # make sure it's query_data not query_db

app = FastAPI()

class ChatRequest(BaseModel):
    query: str

@app.post("/chat")
def chat_endpoint(request: ChatRequest):
    try:
        answer = query_db(request.query)  # only one return value now
        return {
            "query": request.query,
            "answer": answer,
        }
    except Exception as e:
        return {"error": str(e)}



# python -m uvicorn chat_api:app --reload

# $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/chat" -Method POST -Body (@{query="Tell me about BHADAWARI buffalo"} | ConvertTo-Json) -ContentType "application/json"
# $response.answer