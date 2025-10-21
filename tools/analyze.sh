#!/bin/bash

echo "🔍 Ralph Framework - Decision Analysis"
echo ""

if [ ! -f .ralph/decision_history.log ]; then
    echo "❌ No decision history found"
    echo "Run Ralph first: ./ralph.sh"
    exit 1
fi

echo "📊 Model Usage Statistics:"
echo ""

TOTAL=$(wc -l < .ralph/decision_history.log)
HAIKU=$(grep -c "Model: haiku" .ralph/decision_history.log)
SONNET=$(grep -c "Model: sonnet" .ralph/decision_history.log)

if [ $TOTAL -gt 0 ]; then
    HAIKU_PCT=$((HAIKU * 100 / TOTAL))
    SONNET_PCT=$((SONNET * 100 / TOTAL))
    
    echo "   Total Loops: $TOTAL"
    echo "   ⚡ Haiku:  $HAIKU ($HAIKU_PCT%)"
    echo "   🧠 Sonnet: $SONNET ($SONNET_PCT%)"
fi

echo ""
echo "📝 Recent Decisions:"
echo ""
tail -10 .ralph/decision_history.log

echo ""
echo "🎯 Most Common Reasons for Sonnet:"
grep "Model: sonnet" .ralph/decision_history.log | \
    cut -d'|' -f3 | \
    sort | uniq -c | sort -rn | head -5

echo ""