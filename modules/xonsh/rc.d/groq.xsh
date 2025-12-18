def query_groq(system_prompt: str, user_text: str) -> str:
    import os
    from groq import Groq
    client = Groq(api_key=$GROQ_API_KEY)

    completion = client.chat.completions.create(
        model="openai/gpt-oss-120b",
        messages=[
            {
                "role": "system",
                "content": system_prompt
            },
            {
                "role": "user",
                "content": user_text
            },
        ],
        temperature=1,
        max_completion_tokens=8192,
        top_p=1,
        reasoning_effort="medium",
        stream=True,
        stop=None
    )

    chunks = []
    for chunk in completion:
        content = chunk.choices[0].delta.content
        if content:
            chunks.append(content)

    return "".join(chunks)