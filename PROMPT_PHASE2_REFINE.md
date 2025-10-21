# PHASE 2: REFINEMENT & ENHANCEMENT

You are Ralph in refinement mode. The core implementation from fix_plan.md is complete. Now analyze the codebase and identify improvements beyond the original specifications.

## Subagents (if available)
If you have subagents available:
- **searcher**: Code analysis (Haiku) - can run 5-10 in parallel
- **reviewer**: Quality review (Sonnet) - only 1 at a time
- **documenter**: Updates docs (Haiku) - can run 2-5 in parallel

Use subagents to analyze the codebase in parallel for faster results.
If subagents NOT available, you do all analysis yourself.

## Context

- ✅ All tasks from original fix_plan.md are complete
- ✅ Core features from specs are implemented
- 🎯 Now looking for enhancements beyond original scope
- 🎯 Goal: Make the software better, more robust, more maintainable

## Your Task

Perform a comprehensive analysis of the codebase and identify improvements.

### 1. Parallel Code Analysis

**With Subagents (if available):**
Spawn multiple searcher subagents to analyze different aspects in parallel:
````typescript
await Promise.all([
  use_subagent("searcher", {
    task: "Find code duplication and repeated patterns",
    analysis: "Look for similar functions, duplicated logic, copy-pasted code",
    output: "analysis/duplication.md"
  }),
  use_subagent("searcher", {
    task: "Find missing error handling",
    analysis: "Check for try-catch gaps, unhandled promises, silent failures",
    output: "analysis/error-handling.md"
  }),
  use_subagent("searcher", {
    task: "Find performance issues",
    analysis: "Look for N+1 queries, missing indexes, inefficient algorithms, slow operations",
    output: "analysis/performance.md"
  }),
  use_subagent("searcher", {
    task: "Find security vulnerabilities",
    analysis: "Check input validation, SQL injection, XSS, CSRF, authentication bypasses",
    output: "analysis/security.md"
  }),
  use_subagent("searcher", {
    task: "Find missing test coverage",
    analysis: "Identify untested functions, missing edge case tests, no integration tests",
    output: "analysis/testing.md"
  }),
  use_subagent("searcher", {
    task: "Find documentation gaps",
    analysis: "Missing function docs, unclear comments, no API documentation",
    output: "analysis/documentation.md"
  })
]);
````

**Without Subagents:**
Analyze sequentially yourself.

### 2. Detailed Analysis Areas

Examine each of these areas systematically:

#### A. Code Quality

**Look for:**
- **Code duplication:** Same logic in multiple places
- **Complex functions:** Functions >50 lines or deeply nested
- **Magic numbers/strings:** Hard-coded values without constants
- **Inconsistent patterns:** Different styles for similar tasks
- **Poor naming:** Unclear variable/function names
- **Code smells:** Long parameter lists, god objects, etc.

**Example findings:**
````
❌ Found: Authentication logic duplicated in 3 files
✅ Refactor: Extract to auth_utils.py

❌ Found: processUserData() function is 200 lines
✅ Refactor: Split into smaller functions

❌ Found: Hard-coded "admin" string in 5 places  
✅ Refactor: Create USER_ROLES constant
````

#### B. Missing Features

**Look for:**
- Common use cases not covered
- Features that would improve UX significantly
- Admin/management features missing
- Reporting or analytics gaps
- Export/import functionality
- Bulk operations
- Search and filtering
- Pagination for lists
- Sorting options

**Example findings:**
````
💡 Missing: Bulk delete for admin panel
💡 Missing: Export users to CSV
💡 Missing: Search functionality in user list
💡 Missing: Forgot password functionality
💡 Missing: User profile picture upload
````

#### C. Performance

**Look for:**
- N+1 query problems
- Missing database indexes
- Inefficient algorithms (O(n²) where O(n) possible)
- Large data loaded unnecessarily
- Missing caching
- Synchronous operations that could be async
- Memory leaks
- Slow API endpoints

**Example findings:**
````
⚠️  Found: Loading all users in memory (10,000+ records)
✅ Fix: Add pagination

⚠️  Found: No index on users.email (frequent lookups)
✅ Fix: Add database index

⚠️  Found: N+1 queries when loading posts with authors
✅ Fix: Use JOIN or eager loading
````

#### D. Security

**Look for:**
- Missing input validation
- SQL injection vulnerabilities
- XSS vulnerabilities
- CSRF protection missing
- Weak password requirements
- Missing rate limiting
- Exposed sensitive data in logs
- Missing authentication checks
- Authorization bypass possibilities
- Outdated dependencies with CVEs

**Example findings:**
````
🔒 Missing: Rate limiting on login endpoint (brute force risk)
🔒 Missing: Input validation on user bio field (XSS risk)
🔒 Missing: Authorization check in DELETE /api/users/:id
🔒 Missing: HTTPS enforcement
🔒 Found: API keys logged in plain text
````

#### E. Testing

**Look for:**
- Functions without unit tests
- Missing edge case tests
- No integration tests
- No end-to-end tests
- Test coverage gaps
- Brittle tests (dependent on timing, order)
- Missing error condition tests

**Example findings:**
````
📝 Missing: Tests for password reset flow
📝 Missing: Edge case test for empty user list
📝 Missing: Integration test for full auth flow
📝 Found: Only 40% code coverage
📝 Missing: Tests for error handling in payment module
````

#### F. Documentation

**Look for:**
- Missing function/class documentation
- Unclear or outdated comments
- No API documentation
- Missing README sections
- No deployment guide
- No architecture documentation
- Missing inline comments for complex logic

**Example findings:**
````
📚 Missing: API endpoint documentation
📚 Missing: Database schema diagram
📚 Missing: Deployment instructions
📚 Missing: Architecture decision records
📚 Found: Many functions without docstrings
````

#### G. DevOps/Operations

**Look for:**
- Missing logging
- No monitoring/metrics hooks
- Missing health check endpoint
- No graceful shutdown handling
- Missing deployment automation
- No backup strategy
- Missing CI/CD pipeline
- Environment configuration gaps

**Example findings:**
````
🔧 Missing: Structured logging (using print statements)
🔧 Missing: Health check endpoint for load balancer
🔧 Missing: Metrics collection (response times, error rates)
🔧 Missing: Database backup automation
🔧 Missing: CI/CD pipeline configuration
````

### 3. Module-by-Module Review

**With Subagents (if available):**
For each major module, spawn a reviewer subagent (sequential, one at a time):
````typescript
const modules = ["auth", "users", "api", "database", "ui"];

for (const module of modules) {
  await use_subagent("reviewer", {
    task: `Comprehensive review of ${module} module`,
    focus: [
      "code quality",
      "security",
      "performance",
      "test coverage",
      "documentation"
    ],
    severity_levels: ["critical", "high", "medium", "low"],
    output: `reviews/${module}-review.md`
  });
}
````

**Without Subagents:**
Review each module yourself sequentially.

**For each module, check:**
- Does it follow single responsibility?
- Are dependencies clear and minimal?
- Is the interface well-designed?
- Are there coupling issues?
- Is it testable?
- Is it documented?

### 4. Prioritize Findings

Classify all findings by severity and impact:

**CRITICAL** (fix immediately):
- Security vulnerabilities
- Data loss risks
- System stability issues
- Authentication bypasses

**HIGH** (fix soon):
- Performance problems affecting users
- Missing core features users expect
- Major code quality issues
- Significant test gaps

**MEDIUM** (nice to have):
- Minor performance improvements
- Code refactoring for maintainability
- Enhanced features
- Better documentation

**LOW** (polish):
- Minor code style issues
- Nice-to-have features
- Optional optimizations

### 5. Create Refinement Plan

**With Subagents (if available):**
Use documenter subagent to synthesize findings:
````typescript
await use_subagent("documenter", {
  task: "Create comprehensive refinement plan in fix_plan.md",
  input_files: [
    "analysis/duplication.md",
    "analysis/error-handling.md",
    "analysis/performance.md",
    "analysis/security.md",
    "analysis/testing.md",
    "analysis/documentation.md",
    "reviews/*.md"
  ],
  prioritize: true,
  output: "fix_plan.md"
});
````

**Without Subagents:**
Create fix_plan.md yourself.

**Format:**
````markdown
# Refinement & Enhancement Plan

Generated: [Date]
Analysis: [Brief summary of what was analyzed]

## CRITICAL (Fix Immediately)
- [ ] Fix SQL injection in user search endpoint
- [ ] Add authentication to /api/admin/* routes
- [ ] Fix password validation (currently allows "123")

## HIGH Priority
- [ ] Add database indexes for user.email, post.author_id
- [ ] Implement rate limiting on auth endpoints
- [ ] Add pagination to user list (loading 10k+ in memory)
- [ ] Extract duplicated auth logic to utility module
- [ ] Add integration tests for payment flow

## MEDIUM Priority  
- [ ] Refactor UserController (200+ lines, too complex)
- [ ] Add search functionality to user management
- [ ] Implement forgot password feature
- [ ] Add user profile picture upload
- [ ] Create API documentation
- [ ] Add bulk delete for admin operations

## LOW Priority
- [ ] Add user activity logging
- [ ] Improve error messages (more specific)
- [ ] Add export to CSV feature
- [ ] Consistent code formatting throughout project
- [ ] Add code comments to complex algorithms

## Performance Optimizations
- [ ] Fix N+1 query in post listing
- [ ] Add caching for frequently accessed data
- [ ] Optimize image uploads (resize before storage)
- [ ] Async processing for email sending

## Documentation Improvements
- [ ] Write API documentation (OpenAPI/Swagger)
- [ ] Add architecture diagram
- [ ] Document deployment process
- [ ] Add inline comments for complex business logic
- [ ] Create user guide

## Testing Gaps
- [ ] Add tests for authentication edge cases
- [ ] Add tests for permission system
- [ ] Add integration tests for workflows
- [ ] Add load tests for performance validation
- [ ] Reach 80% code coverage minimum

## DevOps/Operations
- [ ] Add structured logging (replace print statements)
- [ ] Add health check endpoint
- [ ] Set up CI/CD pipeline
- [ ] Add monitoring and alerting
- [ ] Document backup/restore procedures
````

### 6. Document Analysis

**With Subagents (if available):**
````typescript
await use_subagent("documenter", {
  task: "Add refinement analysis summary to CLAUDE.md",
  content: `
## Refinement Analysis ([Date])

### Overview
Comprehensive codebase analysis completed. Identified X improvements across
security, performance, code quality, and features.

### Key Findings
- [Summary of critical issues]
- [Summary of high-priority improvements]
- [Summary of opportunities for enhancement]

### Strengths
- [What's working well]
- [Good patterns to maintain]

### Improvement Areas
- [Areas needing attention]

### Next Steps
See fix_plan.md for prioritized refinement tasks.
  `
});
````

**Without Subagents:**
Update CLAUDE.md yourself.

## Output Requirements

After refinement analysis, you must have:

1. ✅ Comprehensive fix_plan.md with categorized improvements
2. ✅ Each item prioritized (CRITICAL, HIGH, MEDIUM, LOW)
3. ✅ Each item is specific and actionable
4. ✅ Updated CLAUDE.md with analysis summary
5. ✅ All findings are realistic and implementable
6. ✅ Security issues clearly marked as CRITICAL
7. ✅ Performance issues quantified where possible

## Guidelines

### Be Realistic
- Don't suggest rewriting everything
- Focus on high-impact improvements
- Consider effort vs. benefit
- Don't over-engineer

### Be Specific
- ❌ Bad: "Improve performance"
- ✅ Good: "Add index on users.email to speed up login queries (current: 200ms, target: <10ms)"

- ❌ Bad: "Better security"
- ✅ Good: "Add rate limiting on POST /api/auth/login (max 5 attempts per minute per IP)"

### Be Pragmatic
- Start with security and stability
- Then performance issues affecting users
- Then code quality and maintainability
- Finally nice-to-have features

### Be Thorough
- Check every module
- Look at every aspect (security, performance, quality, testing, docs)
- Don't skip DevOps concerns
- Consider the full software lifecycle

## Commit Message

After creating refinement plan:
````bash
git add -A
git commit -m "Phase 2: Refinement analysis complete

Comprehensive codebase analysis performed:
- Identified [X] critical security issues
- Found [Y] performance improvements
- Documented [Z] enhancement opportunities
- Created prioritized refinement backlog

Total refinement tasks: [N]
Ready for implementation phase"
````

## When Complete

Output summary:
````
✅ Refinement Analysis Complete

Findings:
- CRITICAL:  X items
- HIGH:      Y items  
- MEDIUM:    Z items
- LOW:       W items

Total refinement tasks: N

All findings documented in fix_plan.md

Next: Run ./ralph.sh to implement refinements
````

---

**NOW: Analyze the codebase comprehensively and create a prioritized refinement plan.**

**Remember:** This is about making good software great. Be thorough, be specific, be realistic.