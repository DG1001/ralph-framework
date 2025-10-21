#!/bin/bash

watch -n 5 '
clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🤖 RALPH FRAMEWORK - Live Monitor                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Phase
if [ -f .ralph/phase.txt ]; then
    PHASE=$(cat .ralph/phase.txt)
    echo "📍 Phase: $PHASE"
else
    echo "📍 Phase: Not started"
fi
echo ""

# Next Model
if [ -f .ralph/next_model.txt ]; then
    MODEL=$(cat .ralph/next_model.txt)
    REASON=$(cat .ralph/model_reason.txt 2>/dev/null || echo "")
    echo "🔮 Next Model: $MODEL"
    echo "   Reason: $REASON"
else
    echo "🔮 Next Model: Not decided"
fi
echo ""

# Stats
COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)
echo "📊 Stats:"
echo "   Commits: $COMMITS"

if [ -f fix_plan.md ]; then
    TOTAL=$(grep -c "^- \[" fix_plan.md 2>/dev/null || echo 0)
    DONE=$(grep -c "^- \[x\]" fix_plan.md 2>/dev/null || echo 0)
    TODO=$(grep -c "^- \[ \]" fix_plan.md 2>/dev/null || echo 0)
    
    if [ $TOTAL -gt 0 ]; then
        PERCENT=$((DONE * 100 / TOTAL))
        echo "   Progress: $DONE/$TOTAL ($PERCENT%)"
        echo "   Remaining: $TODO"
    fi
fi
echo ""

# Recent commits
echo "📝 Recent Commits:"
git log --oneline -5 2>/dev/null | sed "s/^/   /"
echo ""

# Next TODOs
if [ -f fix_plan.md ]; then
    echo "📋 Next TODOs:"
    grep "^- \[ \]" fix_plan.md 2>/dev/null | head -5 | sed "s/^/   /"
fi

echo ""
echo "⏰ $(date "+%H:%M:%S")"
echo "════════════════════════════════════════════════════════════"
'