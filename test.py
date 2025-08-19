from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8003",
    api_key="any"  # ключ не нужен, если нет аутентификации на стороне LiteLLM
)

response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {"role": "user", "content": "Привет!"}
    ]
)

print(response.choices[0].message.content)