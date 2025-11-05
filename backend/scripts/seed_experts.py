"""
Script to seed 10 proposed experts into the database.

Usage:
    python scripts/seed_experts.py
"""

import asyncio
import asyncpg
import os
from datetime import datetime

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

# Sample expert data
EXPERTS_DATA = [
    {
        'name': 'Dr. Sarah Chen',
        'title': 'Chief AI Officer',
        'company': 'Memorial Hospital',
        'description': 'Expert in clinical AI implementation with 15+ years of experience in healthcare technology.',
        'skills': ['Clinical AI', 'Healthcare IT', 'EHR Integration', 'Machine Learning'],
        'rating': 4.8,
        'ai_fit_score': 9,
        'vendor_index': 0
    },
    {
        'name': 'Michael Rodriguez',
        'title': 'VP of Clinical Operations',
        'company': 'Mayo Clinic',
        'description': 'Senior executive with extensive experience in clinical operations and digital health transformation.',
        'skills': ['Clinical Operations', 'Digital Health', 'Process Improvement', 'Healthcare Management'],
        'rating': 4.7,
        'ai_fit_score': 8,
        'vendor_index': 1
    },
    {
        'name': 'Dr. Emily Watson',
        'title': 'Director of Digital Health',
        'company': 'Cleveland Clinic',
        'description': 'Leading expert in digital health initiatives and telemedicine implementation.',
        'skills': ['Digital Health', 'Telemedicine', 'Patient Engagement', 'Healthcare Innovation'],
        'rating': 4.9,
        'ai_fit_score': 9,
        'vendor_index': 2
    },
    {
        'name': 'James Park',
        'title': 'Senior Data Scientist',
        'company': 'Johns Hopkins',
        'description': 'Data science expert specializing in healthcare analytics and predictive modeling.',
        'skills': ['Data Science', 'Healthcare Analytics', 'Predictive Modeling', 'Python', 'R'],
        'rating': 4.6,
        'ai_fit_score': 8,
        'vendor_index': 3
    },
    {
        'name': 'Dr. Lisa Anderson',
        'title': 'Chief Medical Information Officer',
        'company': 'Mass General',
        'description': 'CMIO with deep expertise in clinical informatics and health information systems.',
        'skills': ['Clinical Informatics', 'Health Information Systems', 'EHR', 'Clinical Workflow'],
        'rating': 4.8,
        'ai_fit_score': 9,
        'vendor_index': 4
    },
    {
        'name': 'Robert Kim',
        'title': 'VP of Healthcare Innovation',
        'company': 'Stanford Health',
        'description': 'Innovation leader focused on implementing cutting-edge healthcare technologies.',
        'skills': ['Healthcare Innovation', 'Technology Strategy', 'Digital Transformation', 'Startups'],
        'rating': 4.7,
        'ai_fit_score': 8,
        'vendor_index': 0
    },
    {
        'name': 'Dr. Maria Garcia',
        'title': 'Director of AI Research',
        'company': 'Duke Health',
        'description': 'Research director specializing in AI applications for clinical decision support.',
        'skills': ['AI Research', 'Clinical Decision Support', 'Deep Learning', 'Medical Imaging'],
        'rating': 4.9,
        'ai_fit_score': 10,
        'vendor_index': 1
    },
    {
        'name': 'David Thompson',
        'title': 'Chief Technology Officer',
        'company': 'UCLA Health',
        'description': 'CTO with extensive experience in healthcare technology infrastructure and systems.',
        'skills': ['Healthcare IT', 'Technology Infrastructure', 'Cloud Computing', 'Security'],
        'rating': 4.6,
        'ai_fit_score': 7,
        'vendor_index': 2
    },
    {
        'name': 'Dr. Jennifer Lee',
        'title': 'VP of Clinical Informatics',
        'company': 'Mount Sinai',
        'description': 'Senior leader in clinical informatics with focus on data-driven healthcare delivery.',
        'skills': ['Clinical Informatics', 'Data Analytics', 'Quality Improvement', 'Population Health'],
        'rating': 4.8,
        'ai_fit_score': 9,
        'vendor_index': 3
    },
    {
        'name': 'Christopher Brown',
        'title': 'Senior Director of Digital Transformation',
        'company': 'Cedars-Sinai',
        'description': 'Digital transformation expert with track record of implementing innovative healthcare solutions.',
        'skills': ['Digital Transformation', 'Healthcare Innovation', 'Change Management', 'Strategic Planning'],
        'rating': 4.7,
        'ai_fit_score': 8,
        'vendor_index': 4
    },
]


async def seed_experts():
    """Insert 10 proposed experts into the database."""
    conn = await asyncpg.connect(DATABASE_URL)
    try:
        # Get campaign ID
        campaign = await conn.fetchrow(
            "SELECT id FROM expert_network.campaigns WHERE user_id = $1 LIMIT 1",
            'demo-user-123'
        )
        
        if not campaign:
            print("❌ No campaign found for user 'demo-user-123'")
            print("   Please create a campaign first.")
            return
        
        campaign_id = campaign['id']
        print(f"✓ Found campaign: {campaign_id}")
        
        # Get vendor platform IDs
        vendors = await conn.fetch(
            "SELECT id, name FROM expert_network.vendor_platforms ORDER BY name LIMIT 5"
        )
        
        if not vendors:
            print("❌ No vendor platforms found")
            return
        
        print(f"✓ Found {len(vendors)} vendor platforms")
        vendor_ids = [v['id'] for v in vendors]
        
        # Check if experts already exist
        existing_count = await conn.fetchval(
            "SELECT COUNT(*) FROM expert_network.experts WHERE campaign_id = $1",
            campaign_id
        )
        
        if existing_count > 0:
            print(f"\n⚠️  Found {existing_count} existing experts for this campaign.")
            response = input("Do you want to add 10 more experts? (y/n): ")
            if response.lower() != 'y':
                print("Cancelled.")
                return
        
        # Insert experts
        inserted = []
        for i, expert_data in enumerate(EXPERTS_DATA):
            vendor_id = vendor_ids[expert_data['vendor_index']]
            
            expert_id = await conn.fetchval(
                """
                INSERT INTO expert_network.experts 
                (campaign_id, vendor_platform_id, name, title, company, description, skills, rating, ai_fit_score, status, is_new)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'proposed', true)
                RETURNING id
                """,
                campaign_id,
                vendor_id,
                expert_data['name'],
                expert_data['title'],
                expert_data['company'],
                expert_data['description'],
                expert_data['skills'],
                expert_data['rating'],
                expert_data['ai_fit_score']
            )
            
            inserted.append({
                'id': str(expert_id),
                'name': expert_data['name'],
                'title': expert_data['title'],
                'company': expert_data['company']
            })
            
            print(f"✓ Inserted expert {i+1}/10: {expert_data['name']}")
        
        print(f"\n✅ Successfully inserted {len(inserted)} experts!")
        print("\nExpert Summary:")
        for expert in inserted:
            print(f"  - {expert['name']} ({expert['title']}) at {expert['company']}")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        raise
    finally:
        await conn.close()


if __name__ == "__main__":
    print("Seeding 10 proposed experts into the database...\n")
    asyncio.run(seed_experts())

