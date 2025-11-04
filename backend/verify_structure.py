"""
Verify the API structure is correct by importing all modules.
"""

import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(__file__))

print("=" * 60)
print("Expert Networks API - Structure Verification")
print("=" * 60)
print()

# Test imports
tests = []

# Test database module
try:
    import db
    tests.append(("Database module (db.py)", True, f"Functions: {', '.join([f for f in dir(db) if not f.startswith('_')][:5])}..."))
except Exception as e:
    tests.append(("Database module (db.py)", False, str(e)))

# Test auth module
try:
    from auth import better_auth
    tests.append(("Auth module (auth/better_auth.py)", True, "✓"))
except Exception as e:
    tests.append(("Auth module (auth/better_auth.py)", False, str(e)))

# Test models
model_modules = ["common", "vendor", "project", "campaign", "expert", "interview"]
for module_name in model_modules:
    try:
        exec(f"from models import {module_name}")
        tests.append((f"Model: {module_name}", True, "✓"))
    except Exception as e:
        tests.append((f"Model: {module_name}", False, str(e)))

# Test API routers
api_modules = ["vendors", "projects", "campaigns", "experts", "interviews"]
for module_name in api_modules:
    try:
        exec(f"from api import {module_name}")
        tests.append((f"API router: {module_name}", True, "✓"))
    except Exception as e:
        tests.append((f"API router: {module_name}", False, str(e)))

# Test main app
try:
    from main import app
    tests.append(("Main FastAPI app (main.py)", True, f"Routes: {len(app.routes)}"))
except Exception as e:
    tests.append(("Main FastAPI app (main.py)", False, str(e)))

# Print results
for test_name, passed, detail in tests:
    symbol = "✓" if passed else "✗"
    status = "PASS" if passed else "FAIL"
    print(f"{symbol} {test_name:.<50} {status}")
    if detail and detail != "✓":
        print(f"   {detail}")

# Summary
passed_count = sum(1 for _, passed, _ in tests if passed)
total_count = len(tests)

print()
print("=" * 60)
if passed_count == total_count:
    print(f"✓ All {total_count} components verified successfully!")
    print("=" * 60)
    print()
    print("Your API is ready to use!")
    print()
    print("Start the server:")
    print("  uvicorn main:app --reload")
    print()
    print("View documentation:")
    print("  http://localhost:8000/docs")
else:
    print(f"⚠ {passed_count}/{total_count} components passed")
    print(f"✗ {total_count - passed_count} components failed")
    print("=" * 60)
