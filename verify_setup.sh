#!/bin/bash

###############################################################################
# Devbaytech Setup Verification Script
# Checks if all white label changes and deployment setup is correct
###############################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

check_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Devbaytech Setup Verification            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check branding files
echo -e "${BLUE}[1/6] Checking Branding Files...${NC}"

if grep -q "Devbaytech" README.md 2>/dev/null; then
    check_pass "README.md contains Devbaytech branding"
else
    check_fail "README.md missing Devbaytech branding"
fi

if grep -q "devbaytech.com" apps/public/app/layout.config.tsx 2>/dev/null; then
    check_pass "layout.config.tsx has correct domain"
else
    check_fail "layout.config.tsx missing correct domain"
fi

if grep -q "Devbaytech" apps/start/src/routes/__root.tsx 2>/dev/null; then
    check_pass "__root.tsx has correct title"
else
    check_fail "__root.tsx missing correct title"
fi

echo ""

# Check theme colors
echo -e "${BLUE}[2/6] Checking Theme Colors...${NC}"

if grep -q "FF5A5F\|devbaytech-red" apps/public/app/global.css 2>/dev/null; then
    check_pass "global.css has brand red color"
else
    check_fail "global.css missing brand red color"
fi

if grep -q "2A2A4A\|devbaytech-blue" apps/public/app/global.css 2>/dev/null; then
    check_pass "global.css has brand blue color"
else
    check_fail "global.css missing brand blue color"
fi

if grep -q "devbaytech-red\|devbaytech-blue" apps/start/src/styles.css 2>/dev/null; then
    check_pass "styles.css has brand colors"
else
    check_fail "styles.css missing brand colors"
fi

echo ""

# Check logo files
echo -e "${BLUE}[3/6] Checking Logo Files...${NC}"

if [ -f "apps/start/public/logo.svg" ]; then
    if grep -q "Devbaytech" apps/start/public/logo.svg; then
        check_pass "Start app logo exists with branding"
    else
        check_warning "Logo exists but check branding"
    fi
else
    check_fail "Start app logo missing"
fi

if [ -f "apps/public/public/logo.svg" ]; then
    check_pass "Public app logo exists"
else
    check_fail "Public app logo missing"
fi

if [ -f "apps/public/public/favicon.svg" ]; then
    check_pass "Favicon exists"
else
    check_fail "Favicon missing"
fi

echo ""

# Check deployment scripts
echo -e "${BLUE}[4/6] Checking Deployment Scripts...${NC}"

if [ -f "deploy.sh" ] && [ -x "deploy.sh" ]; then
    check_pass "deploy.sh exists and is executable"
else
    check_fail "deploy.sh missing or not executable"
fi

if [ -f "DEPLOYMENT_GUIDE.md" ]; then
    check_pass "DEPLOYMENT_GUIDE.md exists"
else
    check_fail "DEPLOYMENT_GUIDE.md missing"
fi

if [ -f "QUICK_START.md" ]; then
    check_pass "QUICK_START.md exists"
else
    check_fail "QUICK_START.md missing"
fi

echo ""

# Check email references
echo -e "${BLUE}[5/6] Checking Email/URL References...${NC}"

OPENPANEL_COUNT=$(grep -r "openpanel.dev\|hello@openpanel.dev" apps/start/src apps/public/app --include="*.tsx" --include="*.ts" 2>/dev/null | wc -l)
DEVBAYTECH_COUNT=$(grep -r "devbaytech.com\|hello@devbaytech.com" apps/start/src apps/public/app --include="*.tsx" --include="*.ts" 2>/dev/null | wc -l)

if [ "$DEVBAYTECH_COUNT" -gt 0 ]; then
    check_pass "Found $DEVBAYTECH_COUNT Devbaytech email/URL references"
else
    check_warning "No Devbaytech email/URL references found"
fi

if [ "$OPENPANEL_COUNT" -gt 0 ]; then
    check_warning "Still found $OPENPANEL_COUNT OpenPanel references (check if internal/acceptable)"
fi

echo ""

# Check Docker setup
echo -e "${BLUE}[6/6] Checking Docker Setup...${NC}"

if [ -f "docker-compose.yml" ]; then
    check_pass "docker-compose.yml exists"
else
    check_fail "docker-compose.yml missing"
fi

if [ -f "pnpm-lock.yaml" ]; then
    check_pass "pnpm-lock.yaml exists"
else
    check_fail "pnpm-lock.yaml missing"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}Passed: $PASS${NC}"
echo -e "${RED}Failed: $FAIL${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Ready for deployment.${NC}"
    echo -e "Run ${BLUE}./deploy.sh${NC} to start deployment."
    exit 0
else
    echo -e "${YELLOW}⚠ Some checks failed. Review the issues above.${NC}"
    exit 1
fi
