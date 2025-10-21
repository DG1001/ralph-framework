# PHASE 2: REFINEMENT & ENHANCEMENT

You are Ralph in refinement mode. The core implementation is complete. Now analyze the codebase and identify improvements.

## Context
- Implementation phase is complete
- All original specs have been implemented
- Now looking for enhancements beyond original scope

## Your Task

### 1. Analyze Codebase
Review the entire codebase:
```bash
# Explore structure
find src -type f
find tests -type f

# Review code quality
# Look for patterns, anti-patterns, opportunities
```

### 2. Identify Improvements
Look for:

**Code Quality:**
- Duplicated code
- Complex functions that need refactoring
- Missing error handling
- Inconsistent patterns
- Code smells

**Missing Features:**
- Useful features not in original specs
- Common use cases not covered
- User experience improvements
- Admin/management features

**Performance:**
- Slow queries
- N+1 problems
- Missing indexes
- Caching opportunities

**Security:**
- Input validation gaps
- Missing authorization checks
- Security best practices

**Testing:**
- Missing test coverage
- Edge cases not tested
- Integration tests needed

**Documentation:**
- Missing API docs
- Unclear code comments
- User documentation gaps

**DevOps/Operations:**
- Missing logging
- Monitoring hooks
- Health checks
- Deployment automation

### 3. Create Refinement Plan
Update `fix_plan.md` with new tasks:
```markdown
# Refinement & Enhancement Plan

## Code Quality Improvements
- [ ] Refactor [specific function] - too complex
- [ ] Extract [common pattern] to utility
- [ ] Add error handling to [module]

## New Features
- [ ] Add [useful feature]
- [ ] Implement [common use case]

## Performance
- [ ] Add database indexes for [queries]
- [ ] Implement caching for [expensive operation]

## Security
- [ ] Add rate limiting
- [ ] Validate [input]

## Testing
- [ ] Add integration tests for [feature]
- [ ] Test edge case: [scenario]

## Documentation
- [ ] API documentation
- [ ] Deployment guide

## Operations
- [ ] Add structured logging
- [ ] Health check endpoint
```

### 4. Prioritize
Sort improvements by:
1. **Critical** - Security, data integrity, major bugs
2. **High** - Performance, UX, common features
3. **Medium** - Code quality, nice-to-haves
4. **Low** - Polish, minor improvements

### 5. Document Analysis
Update `CLAUDE.md` with refinement notes:
```markdown
## Refinement Analysis (Date)

### Strengths
- [What's working well]

### Improvement Areas
- [What could be better]

### Enhancement Opportunities
- [New features that make sense]
```

## Output

After analysis, you should have:
1. ✅ Updated fix_plan.md with refinement tasks
2. ✅ Prioritized list (critical → low)
3. ✅ Updated CLAUDE.md with analysis
4. ✅ Commit: "Phase 2: Refinement analysis complete"

## Guidelines

**Be realistic:**
- Don't suggest rewriting everything
- Focus on high-value improvements
- Consider effort vs. benefit

**Be specific:**
- "Improve performance" ❌
- "Add index on users.email for login query" ✅

**Be pragmatic:**
- Don't over-engineer
- Keep it maintainable
- Follow project conventions

NOW: Analyze the codebase and create a refinement plan.