"""Quick script to verify screening responses in the database."""
import asyncio
import asyncpg
import os

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

async def verify():
    conn = await asyncpg.connect(DATABASE_URL)
    try:
        result = await conn.fetch('SELECT COUNT(*) as count FROM expert_network.expert_screening_responses')
        print(f'Total screening responses: {result[0]["count"]}')
        
        result2 = await conn.fetch('SELECT COUNT(DISTINCT expert_id) as count FROM expert_network.expert_screening_responses')
        print(f'Experts with responses: {result2[0]["count"]}')
        
        # Show a sample
        sample = await conn.fetch('''
            SELECT e.name, sq.question_text, esr.response_text
            FROM expert_network.expert_screening_responses esr
            JOIN expert_network.experts e ON esr.expert_id = e.id
            JOIN expert_network.screening_questions sq ON esr.screening_question_id = sq.id
            LIMIT 3
        ''')
        print('\nSample responses:')
        for row in sample:
            print(f'  Expert: {row["name"]}')
            print(f'  Question: {row["question_text"][:60]}...')
            print(f'  Response: {row["response_text"][:80]}...')
            print()
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(verify())

