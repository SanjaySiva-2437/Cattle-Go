# CattleGo RAG Chatbot — Livestock Knowledge Assistant

> A fully local Retrieval-Augmented Generation (RAG) system for querying expert-level information on Indian cattle and buffalo breeds — powered by LangChain, Chroma, and Ollama.

[![Python](https://img.shields.io/badge/Python-3.13-blue)](https://python.org)
[![LangChain](https://img.shields.io/badge/LangChain-latest-green)](https://langchain.com)
[![Ollama](https://img.shields.io/badge/Ollama-gemma3-orange)](https://ollama.com)
[![FastAPI](https://img.shields.io/badge/FastAPI-REST-teal)](https://fastapi.tiangolo.com)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

---

## Overview

The CattleGo RAG Chatbot enables farmers, researchers, and livestock professionals to ask natural language questions about cattle and buffalo breeds — and receive accurate, document-grounded answers in real time.

Rather than relying on a generic LLM's parametric memory, this system retrieves relevant content directly from a curated knowledge base of breed documentation, then synthesizes a precise, context-aware response. The result is a chatbot that stays factually grounded and can be updated simply by adding new markdown files — no retraining required.

The system is **fully local**, requiring no external API calls, and runs efficiently on both GPU and CPU hardware.

---

## How It Works

```
User Query
    │
    ▼
Embed query (nomic-embed-text via Ollama)
    │
    ▼
Semantic search over Chroma vector DB
    │
    ▼
Retrieve top-k relevant document chunks
    │
    ▼
Prompt Ollama LLM (gemma3:12b / gemma3:3b) with context + query
    │
    ▼
Return grounded, human-readable response
```

This RAG architecture eliminates hallucination on domain-specific livestock queries by anchoring every response in retrieved source material.

---

## Features

- **Local-first** — no OpenAI or external API dependency; runs entirely on your machine
- **Semantic retrieval** — embeds and indexes breed documents using `nomic-embed-text` for high-quality similarity search
- **Flexible LLM backend** — supports `gemma3:12b` for accuracy or `gemma3:3b` for memory-constrained environments
- **REST API** — FastAPI endpoint for integration with the CattleGo mobile backend
- **Hot-swappable knowledge base** — update the chatbot's knowledge by dropping new `.md` files; no retraining needed
- **GPU & CPU friendly** — works on consumer hardware with graceful fallback

---

## Demo

> **User:** "Tell me about Gir cattle"

> **CattleGo:** *"The Gir cattle, also known as 'Bhodali', 'Desan', 'Gujarati', 'Kathiawari', 'Sorthi', and 'Surati', is a native breed from the Saurashtra region of Gujarat. They are recognizable by their distinctive red color and uniquely curved half-moon shaped horns. Gir cattle are known for their high lactation yield, averaging 2110 kg per year..."*

---

## Project Structure

```
rag-chatbot/
├── api/                    # FastAPI REST endpoint for backend integration
├── config/                 # Configuration files (models, chunking params, paths)
├── data/
│   └── books/              # Markdown files — breed knowledge base
├── ingestion/              # Ingestion pipeline: load → chunk → embed → store
├── retrieval/              # Semantic search and LLM query logic
├── vectorstore/
│   └── chroma_db/          # Persisted Chroma vector database (auto-generated)
└── README.md
```

---

## Quickstart

### Prerequisites

- Python 3.13+
- [Ollama](https://ollama.com) installed and running locally
- Required models pulled:

```bash
ollama pull nomic-embed-text
ollama pull gemma3:12b       # or gemma3:3b for lower memory
```

### Installation

```bash
git clone https://github.com/your-org/Cattle-GO.git
cd Cattle-GO/rag-chatbot
pip install -r requirements.txt
```

---

## Usage

### 1. Build the Vector Database

```bash
python create_database.py
```

Loads all `.md` files from `data/books/`, splits them into 500-character chunks with 50-character overlap, embeds each chunk using `nomic-embed-text`, and persists the vector store to `chroma_db/`.

### 2. Query via CLI

```bash
python query_data.py "Tell me about Bhadawari buffalo"
```

Performs semantic search over the vector DB, retrieves the top-k relevant chunks, and passes them as context to the Ollama LLM for a grounded response.

### 3. Run the REST API

```bash
uvicorn chat_api:app --host 0.0.0.0 --port 8000
```

**Example request (PowerShell):**
```powershell
$response = Invoke-RestMethod `
  -Uri "http://127.0.0.1:8000/chat" `
  -Method POST `
  -Body (@{query="Tell me about Bhadawari buffalo"} | ConvertTo-Json) `
  -ContentType "application/json"

$response.answer
```

**Example request (curl):**
```bash
curl -X POST http://127.0.0.1:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"query": "Tell me about Bhadawari buffalo"}'
```

---

## Configuration

| Parameter         | Default         | Description                              |
|-------------------|-----------------|------------------------------------------|
| LLM Model         | `gemma3:12b`    | Swap to `gemma3:3b` for <8 GB RAM        |
| Embedding Model   | `nomic-embed-text` | Ollama embedding model                |
| Chunk Size        | 500 chars       | Document split size for indexing         |
| Chunk Overlap     | 50 chars        | Overlap between consecutive chunks      |
| Vector Store      | Chroma (local)  | Persisted to `chroma_db/`               |

---

## Tech Stack

| Component     | Technology                     |
|---------------|-------------------------------|
| LLM Backend   | Ollama (`gemma3:12b / 3b`)    |
| Embeddings    | `nomic-embed-text` via Ollama |
| Vector Store  | Chroma                        |
| RAG Framework | LangChain                     |
| API Layer     | FastAPI + Pydantic            |
| Runtime       | Python 3.13                   |

---

## Roadmap

- [ ] Streaming responses via FastAPI `StreamingResponse`
- [ ] Conversation memory for multi-turn dialogue
- [ ] Source citation in responses (chunk provenance)
- [ ] Web UI (React / Flutter integration with CattleGo app)
- [ ] Expand knowledge base to include disease diagnosis and treatment docs
- [ ] Hybrid search (BM25 + semantic) for improved retrieval precision
- [ ] Docker containerization for one-command deployment

---

## Contributing

Pull requests are welcome. To add new breed documentation, simply drop a `.md` file into `data/books/` and re-run `create_database.py`. For larger changes, please open an issue first.

---

## License

[MIT](LICENSE)

---

*Part of the CattleGo platform — an agri-tech solution for livestock management in India.*