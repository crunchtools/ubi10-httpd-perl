#!/bin/bash
# smoke-test.sh — smoke tests for ubi10-httpd-perl container image
# Run inside a running container started with --systemd=always
# Exit 0 = all pass, Exit 1 = one or more failures

set -uo pipefail

FAILURES=0
TESTS=0

pass() {
    TESTS=$((TESTS + 1))
    echo "  PASS: $1"
}

fail() {
    TESTS=$((TESTS + 1))
    FAILURES=$((FAILURES + 1))
    echo "  FAIL: $1"
}

# ---------- Service Health ----------
echo "=== Service Health ==="

if systemctl is-active httpd >/dev/null 2>&1; then
    pass "httpd is active"
else
    fail "httpd is not active"
fi

# ---------- Negative Assertion ----------
echo "=== Negative Assertions ==="

# mariadb-server must NOT be installed — databases belong in leaf images
if rpm -q mariadb-server >/dev/null 2>&1; then
    fail "mariadb-server is installed (should be in leaf images only)"
else
    pass "mariadb-server NOT installed (correct)"
fi

# ---------- Functional Tests ----------
echo "=== Functional Tests ==="

# mod_fcgid loaded
if httpd -M 2>/dev/null | grep -q "fcgid_module"; then
    pass "mod_fcgid loaded in httpd"
else
    fail "mod_fcgid not loaded in httpd"
fi

# Perl present
if perl --version >/dev/null 2>&1; then
    pass "perl is available"
else
    fail "perl is not available"
fi

# ---------- Package Integrity ----------
echo "=== Package Integrity ==="

PACKAGES=(mod_fcgid perl)
for pkg in "${PACKAGES[@]}"; do
    if rpm -q "$pkg" >/dev/null 2>&1; then
        pass "package: $pkg"
    else
        fail "package missing: $pkg"
    fi
done

# ---------- Inherited (ubi10-httpd + ubi10-core) ----------
echo "=== Inherited ==="

INHERITED_PACKAGES=(httpd iputils bind-utils net-tools less cronie procps-ng diffutils)
for pkg in "${INHERITED_PACKAGES[@]}"; do
    if rpm -q "$pkg" >/dev/null 2>&1; then
        pass "inherited package: $pkg"
    else
        fail "inherited package missing: $pkg"
    fi
done

# ---------- Summary ----------
echo ""
echo "=== Results: $((TESTS - FAILURES))/$TESTS passed ==="

if [ "$FAILURES" -gt 0 ]; then
    echo "$FAILURES test(s) failed"
    exit 1
fi

echo "All tests passed"
exit 0
