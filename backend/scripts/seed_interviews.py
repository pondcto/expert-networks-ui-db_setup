"""
Script to seed 20 sample interviews into the database.

Usage:
    python scripts/seed_interviews.py
"""

import asyncio
import asyncpg
import os
from datetime import datetime, date, time, timedelta
import random

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:123456@localhost:5432/ragdb')

# Sample interview data with various statuses and times
INTERVIEWS_DATA = [
    # Completed interviews (with notes and insights)
    {
        'status': 'completed',
        'duration_minutes': 60,
        'interview_notes': 'Excellent discussion on AI implementation in clinical settings. Expert provided detailed insights on data quality requirements.',
        'key_insights': '1. Data quality is critical for AI success\n2. Physician buy-in is essential\n3. Integration with existing EHR systems is challenging',
        'transcript_text': 'Interview transcript: Discussion covered AI implementation challenges, data quality requirements, and physician adoption strategies.',
        'interviewer_name': 'John Smith',
    },
    {
        'status': 'completed',
        'duration_minutes': 45,
        'interview_notes': 'Focused on digital health transformation strategies. Expert shared real-world examples from their organization.',
        'key_insights': '1. Change management is key\n2. Patient engagement tools are critical\n3. ROI can be measured through patient outcomes',
        'transcript_text': 'Interview transcript: Covered digital health transformation, change management strategies, and patient engagement tools.',
        'interviewer_name': 'Sarah Johnson',
    },
    {
        'status': 'completed',
        'duration_minutes': 90,
        'interview_notes': 'Deep dive into healthcare analytics and predictive modeling. Expert discussed machine learning applications.',
        'key_insights': '1. Predictive models need high-quality data\n2. Feature engineering is important\n3. Model interpretability is crucial for clinical adoption',
        'transcript_text': 'Interview transcript: Detailed discussion on healthcare analytics, predictive modeling, and machine learning applications.',
        'interviewer_name': 'Michael Chen',
    },
    {
        'status': 'completed',
        'duration_minutes': 60,
        'interview_notes': 'Clinical informatics and EHR integration discussion. Expert shared implementation challenges and solutions.',
        'key_insights': '1. EHR integration is complex\n2. Workflow optimization is necessary\n3. Training is critical for success',
        'transcript_text': 'Interview transcript: Discussion on clinical informatics, EHR integration challenges, and workflow optimization.',
        'interviewer_name': 'Emily Davis',
    },
    {
        'status': 'completed',
        'duration_minutes': 75,
        'interview_notes': 'Healthcare innovation and technology strategy. Expert discussed startup ecosystem and emerging technologies.',
        'key_insights': '1. Startups are driving innovation\n2. Telemedicine is growing rapidly\n3. AI adoption is accelerating',
        'transcript_text': 'Interview transcript: Covered healthcare innovation, technology strategy, startup ecosystem, and emerging technologies.',
        'interviewer_name': 'Robert Kim',
    },
    # Scheduled interviews (upcoming)
    {
        'status': 'scheduled',
        'duration_minutes': 60,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'John Smith',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 45,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Sarah Johnson',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 90,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Michael Chen',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 60,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Emily Davis',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 75,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Robert Kim',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 60,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'John Smith',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 45,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Sarah Johnson',
    },
    # Cancelled interviews
    {
        'status': 'cancelled',
        'duration_minutes': 60,
        'interview_notes': 'Expert cancelled due to scheduling conflict.',
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'John Smith',
    },
    {
        'status': 'cancelled',
        'duration_minutes': 45,
        'interview_notes': 'Rescheduled at expert request.',
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Sarah Johnson',
    },
    # No-show interviews
    {
        'status': 'no_show',
        'duration_minutes': 60,
        'interview_notes': 'Expert did not attend the scheduled interview.',
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'John Smith',
    },
    {
        'status': 'no_show',
        'duration_minutes': 45,
        'interview_notes': 'Expert did not respond to interview invitation.',
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Sarah Johnson',
    },
    # More completed interviews
    {
        'status': 'completed',
        'duration_minutes': 60,
        'interview_notes': 'AI research and clinical decision support discussion. Expert shared insights on deep learning applications.',
        'key_insights': '1. Deep learning shows promise\n2. Clinical decision support is evolving\n3. Medical imaging AI is advancing rapidly',
        'transcript_text': 'Interview transcript: Discussion on AI research, clinical decision support, and deep learning applications in healthcare.',
        'interviewer_name': 'Michael Chen',
    },
    {
        'status': 'completed',
        'duration_minutes': 45,
        'interview_notes': 'Healthcare IT infrastructure and cloud computing. Expert discussed security and scalability considerations.',
        'key_insights': '1. Cloud adoption is growing\n2. Security is paramount\n3. Scalability is important for growth',
        'transcript_text': 'Interview transcript: Covered healthcare IT infrastructure, cloud computing, security, and scalability considerations.',
        'interviewer_name': 'Emily Davis',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 60,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'Robert Kim',
    },
    {
        'status': 'scheduled',
        'duration_minutes': 90,
        'interview_notes': None,
        'key_insights': None,
        'transcript_text': None,
        'interviewer_name': 'John Smith',
    },
]


async def seed_interviews():
    """Insert 20 sample interviews into the database."""
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
        
        # Get expert IDs
        experts = await conn.fetch(
            "SELECT id, name FROM expert_network.experts WHERE campaign_id = $1 ORDER BY created_at",
            campaign_id
        )
        
        if not experts:
            print("❌ No experts found for this campaign")
            print("   Please run seed_experts.py first to create experts.")
            return
        
        print(f"✓ Found {len(experts)} experts")
        
        # Check if interviews already exist
        existing_count = await conn.fetchval(
            "SELECT COUNT(*) FROM expert_network.interviews WHERE campaign_id = $1",
            campaign_id
        )
        
        if existing_count > 0:
            print(f"\n⚠️  Found {existing_count} existing interviews for this campaign.")
            response = input("Do you want to add 20 more interviews? (y/n): ")
            if response.lower() != 'y':
                print("Cancelled.")
                return
        
        # Generate dates and times for interviews
        # Start from today and spread over the next 4 weeks
        today = date.today()
        base_times = [
            time(9, 0),   # 9:00 AM
            time(10, 30), # 10:30 AM
            time(14, 0),  # 2:00 PM
            time(15, 30), # 3:30 PM
            time(16, 0),  # 4:00 PM
        ]
        
        # Insert interviews
        inserted = []
        for i, interview_data in enumerate(INTERVIEWS_DATA):
            # Select expert (cycle through available experts)
            expert = experts[i % len(experts)]
            expert_id = expert['id']
            
            # Calculate interview date (spread over 4 weeks)
            days_offset = (i // 5) * 3 + (i % 5)  # Spread interviews across weeks
            interview_date = today + timedelta(days=days_offset)
            
            # For completed interviews, set them in the past
            if interview_data['status'] == 'completed':
                interview_date = today - timedelta(days=random.randint(1, 14))
            # For cancelled and no_show, set them in the past
            elif interview_data['status'] in ['cancelled', 'no_show']:
                interview_date = today - timedelta(days=random.randint(1, 7))
            
            # Select time from base times
            interview_time = base_times[i % len(base_times)]
            
            # Insert interview
            # Note: The database schema has scheduled_date and scheduled_time as separate fields
            # The schema doesn't have user_id, interview_notes, key_insights, transcript_text, or interviewer_name
            # We'll only insert the fields that exist in the schema
            interview_id = await conn.fetchval(
                """
                INSERT INTO expert_network.interviews 
                (campaign_id, expert_id, scheduled_date, scheduled_time, duration_minutes, 
                 status, timezone)
                VALUES ($1, $2, $3, $4, $5, $6, $7)
                RETURNING id
                """,
                campaign_id,
                expert_id,
                interview_date,
                interview_time,
                interview_data['duration_minutes'],
                interview_data['status'],
                'America/New_York',  # GMT-5 timezone
            )
            
            # For completed interviews, set completed_at timestamp
            if interview_data['status'] == 'completed':
                await conn.execute(
                    "UPDATE expert_network.interviews SET completed_at = NOW() WHERE id = $1",
                    interview_id
                )
            # For cancelled interviews, set cancelled_at timestamp
            elif interview_data['status'] == 'cancelled':
                await conn.execute(
                    "UPDATE expert_network.interviews SET cancelled_at = NOW() WHERE id = $1",
                    interview_id
                )
            
            inserted.append({
                'id': str(interview_id),
                'expert': expert['name'],
                'date': str(interview_date),
                'time': str(interview_time),
                'status': interview_data['status'],
                'duration': interview_data['duration_minutes']
            })
            
            print(f"✓ Inserted interview {i+1}/20: {expert['name']} - {interview_date} {interview_time} ({interview_data['status']})")
        
        print(f"\n✅ Successfully inserted {len(inserted)} interviews!")
        print("\nInterview Summary:")
        status_counts = {}
        for interview in inserted:
            status = interview['status']
            status_counts[status] = status_counts.get(status, 0) + 1
            print(f"  - {interview['expert']}: {interview['date']} {interview['time']} ({status}, {interview['duration']} min)")
        
        print("\nStatus Breakdown:")
        for status, count in status_counts.items():
            print(f"  - {status}: {count}")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        raise
    finally:
        await conn.close()


if __name__ == "__main__":
    print("Seeding 20 sample interviews into the database...\n")
    asyncio.run(seed_interviews())

