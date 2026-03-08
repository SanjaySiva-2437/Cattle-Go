#create_database.py
from langchain_community.document_loaders import TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_chroma import Chroma
from langchain_ollama import OllamaEmbeddings
import os
import shutil
import glob

DATA_PATH = "data/books"
CHROMA_PATH = "chroma_db"

def main():
    generate_data_store()

def generate_data_store():
    # Collect all .md files in DATA_PATH
    files = glob.glob(os.path.join(DATA_PATH, "*.md"))
    documents = []

    for file in files:
        loader = TextLoader(file, encoding="utf-8")
        docs = loader.load()
        documents.extend(docs)

    print(f"Loaded {len(documents)} documents.")

    # Split documents into chunks
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        length_function=len,
        add_start_index=True
    )
    chunks = text_splitter.split_documents(documents)
    print(f"Split into {len(chunks)} chunks.")

    # Clear old DB
    if os.path.exists(CHROMA_PATH):
        shutil.rmtree(CHROMA_PATH)

    # Use Ollama embeddings
    embedding_function = OllamaEmbeddings(model="nomic-embed-text")

    # Save chunks to Chroma
    db = Chroma.from_documents(
    chunks,
    embedding=embedding_function,
    persist_directory=CHROMA_PATH
 )

    
    print(f"✅ Database created with {len(chunks)} chunks at '{CHROMA_PATH}'.")

if __name__ == "__main__":
    main()
