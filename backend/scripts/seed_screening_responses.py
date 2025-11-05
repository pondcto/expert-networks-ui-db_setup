"""
Script to seed sample screening responses into the database.

This script creates sample screening question responses for existing experts.
It matches experts with screening questions from their campaigns.

Usage:
    python scripts/seed_screening_responses.py
"""

import asyncio
import asyncpg
import os
from datetime import datetime

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

# Sample responses that will be matched to questions
SAMPLE_RESPONSES = [
    "I have 8+ years of experience in pharmaceutical market research, including 3 years at McKinsey focusing on drug pricing strategies and market access. I've led research projects for top 10 pharma companies on oncology, rare diseases, and digital therapeutics.",
    "I use a multi-source approach combining primary research, secondary data analysis, and expert interviews. I've developed proprietary frameworks for analyzing competitor pipelines, pricing strategies, and market positioning that have helped clients identify $2B+ in market opportunities.",
    "I've worked extensively with FDA regulations, HIPAA compliance, and international regulatory frameworks. I've helped clients navigate complex approval processes and have experience with real-world evidence studies and post-market surveillance requirements.",
    "I've led digital transformation initiatives for 3 major banks and 2 fintech companies. At McKinsey, I helped a top-5 bank implement a $500M digital banking platform, resulting in 40% improvement in customer satisfaction and 25% reduction in operational costs.",
    "I use a structured approach combining stakeholder analysis, communication strategies, and training programs. I've successfully managed change for 50,000+ employees across multiple organizations, achieving 90%+ adoption rates for new systems and processes.",
    "I'm particularly interested in embedded finance, open banking, and AI-driven personalization. I've advised 5 fintech startups on go-to-market strategies and have deep insights into regulatory trends and consumer adoption patterns in digital financial services.",
    "I've conducted due diligence on 50+ healthcare companies, including medtech, biotech, and digital health startups. I've worked with 3 major PE firms and have deep expertise in FDA approval processes, reimbursement models, and market sizing for healthcare technologies.",
    "I focus on market size, competitive moats, team quality, and unit economics. I've developed proprietary frameworks for assessing SaaS metrics, customer acquisition costs, and lifetime value. My analysis has influenced $1B+ in investment decisions across 100+ technology companies.",
    "I'm particularly excited about AI/ML applications, climate tech, and digital health. I've been tracking these sectors closely and have identified several emerging opportunities in enterprise AI, carbon capture technologies, and personalized medicine platforms.",
    "I've led AI/ML implementations at 2 Fortune 500 companies, including a $100M digital transformation project. I've built ML pipelines serving 10M+ users, implemented MLOps practices, and have experience with AWS, Azure, and GCP cloud platforms.",
    "I design for scalability, security, and cost optimization. I've architected systems handling 100M+ daily transactions using microservices, containerization, and auto-scaling. My architectures have reduced infrastructure costs by 40% while improving performance by 60%.",
    "The main challenges are balancing technical debt with feature delivery, managing remote teams effectively, and keeping up with rapidly evolving technologies. I've successfully led 50+ person engineering teams and have developed frameworks for technical decision-making and team productivity.",
    "I've developed omnichannel strategies for 5 major CPG brands, including a Fortune 100 company's digital transformation that increased online sales by 60%. I have deep expertise in customer journey mapping, channel integration, and personalization at scale.",
    "I use a combination of quantitative data analysis, qualitative research, and behavioral psychology principles. I've conducted 200+ consumer studies and have developed proprietary models for predicting purchase behavior and brand loyalty across different demographic segments.",
    "I'm seeing significant impact from social commerce, influencer partnerships, and AI-driven personalization. I've helped brands achieve 3x ROI improvements through integrated digital campaigns and have expertise in privacy-compliant customer data strategies.",
    "I've built recommendation systems for 3 major e-commerce platforms serving 50M+ users. My PhD research on collaborative filtering was published in top ML conferences. I've implemented real-time recommendation engines that increased conversion rates by 35% and average order value by 20%.",
    "I use rigorous statistical methods including multi-armed bandits and Bayesian optimization. I've designed and executed 100+ A/B tests for ML models, ensuring statistical significance and proper control for confounding variables. My testing frameworks have improved model performance by 25% on average.",
    "The main challenges are model drift, data quality issues, and maintaining consistency between training and inference. I've built MLOps pipelines that monitor model performance in real-time and have experience with automated retraining and rollback strategies.",
]


async def seed_screening_responses():
    """Insert sample screening responses for existing experts."""
    conn = await asyncpg.connect(DATABASE_URL)
    try:
        # Get all experts with their campaigns
        experts = await conn.fetch("""
            SELECT e.id as expert_id, e.name, e.campaign_id, c.campaign_name
            FROM expert_network.experts e
            JOIN expert_network.campaigns c ON e.campaign_id = c.id
            ORDER BY e.created_at
        """)
        
        if not experts:
            print("❌ No experts found in the database")
            print("   Please run seed_experts.py first to create experts.")
            return
        
        print(f"✓ Found {len(experts)} experts")
        
        # Get all screening questions grouped by campaign
        questions_by_campaign = {}
        all_questions = await conn.fetch("""
            SELECT id, campaign_id, question_text, parent_question_id
            FROM expert_network.screening_questions
            WHERE parent_question_id IS NULL
            ORDER BY campaign_id, display_order
        """)
        
        for q in all_questions:
            campaign_id = str(q['campaign_id'])
            if campaign_id not in questions_by_campaign:
                questions_by_campaign[campaign_id] = []
            questions_by_campaign[campaign_id].append(q)
        
        if not questions_by_campaign:
            print("❌ No screening questions found in the database")
            print("   Please create screening questions for campaigns first.")
            return
        
        print(f"✓ Found screening questions for {len(questions_by_campaign)} campaigns")
        
        # Check existing responses
        existing_count = await conn.fetchval(
            "SELECT COUNT(*) FROM expert_network.expert_screening_responses"
        )
        
        if existing_count > 0:
            print(f"\n⚠️  Found {existing_count} existing screening responses.")
            response = input("Do you want to add more responses? (y/n): ")
            if response.lower() != 'y':
                print("Cancelled.")
                return
        
        # Insert responses
        inserted_count = 0
        response_index = 0
        
        for expert in experts:
            expert_id = str(expert['expert_id'])
            campaign_id = str(expert['campaign_id'])
            
            # Get questions for this expert's campaign
            campaign_questions = questions_by_campaign.get(campaign_id, [])
            
            if not campaign_questions:
                print(f"⚠️  No questions found for expert {expert['name']} (campaign: {expert.get('campaign_name', 'Unknown')})")
                continue
            
            # Create responses for up to 3 questions per expert
            num_responses = min(3, len(campaign_questions))
            
            for i in range(num_responses):
                question = campaign_questions[i]
                question_id = str(question['id'])
                
                # Use response text from our pool, cycling through
                response_text = SAMPLE_RESPONSES[response_index % len(SAMPLE_RESPONSES)]
                response_index += 1
                
                # Check if this expert already has a response for this question
                existing = await conn.fetchval("""
                    SELECT id FROM expert_network.expert_screening_responses
                    WHERE expert_id = $1 AND screening_question_id = $2
                """, expert_id, question_id)
                
                if existing:
                    continue  # Skip if response already exists
                
                # Insert the response
                await conn.execute("""
                    INSERT INTO expert_network.expert_screening_responses
                    (expert_id, screening_question_id, response_text)
                    VALUES ($1, $2, $3)
                """, expert_id, question_id, response_text)
                
                inserted_count += 1
                print(f"✓ Added response for {expert['name']} to question: {question['question_text'][:60]}...")
        
        print(f"\n✅ Successfully inserted {inserted_count} screening responses!")
        
        # Show summary
        summary = await conn.fetch("""
            SELECT 
                COUNT(DISTINCT expert_id) as experts_with_responses,
                COUNT(*) as total_responses
            FROM expert_network.expert_screening_responses
        """)
        
        if summary:
            stats = summary[0]
            print(f"\nSummary:")
            print(f"  - Experts with responses: {stats['experts_with_responses']}")
            print(f"  - Total responses: {stats['total_responses']}")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        await conn.close()


if __name__ == "__main__":
    print("Seeding sample screening responses into the database...\n")
    asyncio.run(seed_screening_responses())

