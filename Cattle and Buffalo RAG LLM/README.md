# Cattle & Buffalo RAG LLM

A Retrieval-Augmented Generation (RAG) system for querying information about cattle and buffalo breeds using **LangChain**, **Chroma**, and **Ollama LLMs**. This project allows you to create a local document database, embed it, and interact with it via Python scripts or a FastAPI web service.

---

## Features

- Create a vector database from `.md` documents using **Chroma**.
- Use **Ollama embeddings** (`nomic-embed-text`) to encode text chunks.
- Query the database using a **12B or smaller Ollama LLM** (`gemma3:12b` or `gemma3:3b`).
- Expose a **FastAPI endpoint** for programmatic queries.
- Fully local and GPU/CPU friendly.

---

# Project Structure

## Cattle-and-Buffalo-RAG-LLM/

│

├─ data/books/ # Markdown files containing breed information

├─ chroma_db/ # Persisted vector database (auto-generated)

├─ create_database.py # Script to load documents and create vector DB

├─ query_data.py # Script to query the database using LLM

├─ chat_api.py # FastAPI app to expose a REST endpoint

├─ requirements.txt # Python dependencies

└─ README.md

# Usage
## 1. Create Database
python create_database.py
Loads all .md files from data/books/.
Splits documents into chunks (500 characters with 50 overlap).
Creates a vector database in chroma_db/.

## 2. Query Database via Python
python query_data.py "Tell me about BHADAWARI buffalo"
Uses Ollama LLM (gemma3:12b or smaller) to answer questions.
Returns a human-like response based on the document context.

## 3. Run FastAPI Endpoint
uvicorn chat_api:app --host 0.0.0.0 --port 8000
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/chat" -Method POST -Body (@{query="Tell me about BHADAWARI buffalo"} | ConvertTo-Json) -ContentType "application/json"
$response.answer

## Tips
For systems with <8 GB RAM, use gemma3:3b instead of gemma3:12b.
Precompute embeddings separately if memory is constrained.
Ensure Ollama server is running before creating database or querying.

## Dependencies
Python 3.13
LangChain
Chroma
Ollama
FastAPI & Pydantic
