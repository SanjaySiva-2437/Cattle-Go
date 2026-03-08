# query_data.py
import argparse
from langchain_chroma import Chroma
from langchain_ollama import OllamaLLM, OllamaEmbeddings
from langchain.chains import RetrievalQA
from langchain.prompts import ChatPromptTemplate

CHROMA_PATH = "chroma_db"

# Custom prompt template
PROMPT_TEMPLATE = """
You are a professional AI assistant. Answer in a human-like manner.
Answer the question using ONLY the information provided in the context.
If the answer is not in the context, answer based on your own knowledge.

Context:
{context}

Question: {question}

Answer:
"""

def query_db(query_text: str):
    # Local embeddings
    embedding_function = OllamaEmbeddings(model="nomic-embed-text")

    # Load DB
    db = Chroma(persist_directory=CHROMA_PATH, embedding_function=embedding_function)
    retriever = db.as_retriever()

    # LLM
    llm = OllamaLLM(model="gemma3:12b")

    # Prompt
    prompt = ChatPromptTemplate.from_template(PROMPT_TEMPLATE)

    # RetrievalQA chain
    qa = RetrievalQA.from_chain_type(
        llm=llm,
        retriever=retriever,
        return_source_documents=False,  # ✅ don’t fetch sources
        chain_type_kwargs={"prompt": prompt}
    )

    # Query
    result = qa.invoke({"query": query_text})
    return result["result"]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("query_text", type=str, help="The question to ask the DB")
    args = parser.parse_args()

    answer = query_db(args.query_text)
    print("\nAnswer:\n", answer)





# ollama serve
# python create_database.py
# python query_data.py "Tell me about Pandharpuri buffalo"
# python query_data.py "Tell me about BHADAWARI buffalo"  
