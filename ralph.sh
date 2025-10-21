#!/bin/bash

# Ralph Framework - Universal Autonomous Development
# Version 1.1.0 with Subagents Support

set -e

VERSION="1.1.0"
LOOP_COUNT=0
MAX_LOOPS=2000

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
RALPH_DIR=".ralph"
STATE_FILE="$RALPH_DIR/state.txt"
PHASE_FILE="$RALPH_DIR/phase.txt"
NEXT_MODEL_FILE="$RALPH_DIR/next_model.txt"
MODEL_REASON_FILE="$RALPH_DIR/model_reason.txt"
HISTORY_FILE="$RALPH_DIR/decision_history.log"

# Subagents
SUBAGENTS_FILE="subagents.json"
USE_SUBAGENTS=false

# Stats
HAIKU_COUNT=0
SONNET_COUNT=0

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🤖 RALPH FRAMEWORK v$VERSION                              ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  Autonomous Development: Spec → Implement → Refine      ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

init_ralph() {
    echo -e "${GREEN}🔧 Initializing Ralph...${NC}"
    
    # Create directories
    mkdir -p "$RALPH_DIR"
    mkdir -p specs
    mkdir -p src
    mkdir -p tests
    
    # Check for subagents config
    if [ -f "$SUBAGENTS_FILE" ]; then
        USE_SUBAGENTS=true
        echo -e "${GREEN}✅ Subagents enabled (found $SUBAGENTS_FILE)${NC}"
    else
        echo -e "${YELLOW}⚠️  No subagents.json - running without subagents${NC}"
    fi
    
    # Initialize Git if not exists
    if [ ! -d .git ]; then
        git init
        git config user.name "Ralph"
        git config user.email "ralph@framework.local"
        echo -e "${GREEN}✅ Git repository initialized${NC}"
    fi
    
    # Initialize state files
    [ ! -f "$STATE_FILE" ] && echo "initialized" > "$STATE_FILE"
    [ ! -f "$PHASE_FILE" ] && echo "0" > "$PHASE_FILE"
    [ ! -f "$HISTORY_FILE" ] && touch "$HISTORY_FILE"
    
    echo -e "${GREEN}✅ Ralph initialized${NC}"
}

check_requirements() {
    # Check if claude is installed
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}❌ Claude Code not found${NC}"
        echo "Install with: npm install -g @anthropic-ai/claude-code"
        exit 1
    fi
    
    # Check if plan.md exists
    if [ ! -f "plan.md" ]; then
        echo -e "${RED}❌ plan.md not found${NC}"
        echo "Create plan.md with your project description"
        echo "See plan.md.template for guidance"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Requirements check passed${NC}"
}

get_phase() {
    if [ -f "$PHASE_FILE" ]; then
        cat "$PHASE_FILE"
    else
        echo "0"
    fi
}

set_phase() {
    echo "$1" > "$PHASE_FILE"
}

log_decision() {
    local loop=$1
    local model=$2
    local reason=$3
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Loop #$loop | Model: $model | Reason: $reason" >> "$HISTORY_FILE"
}

# Function to run Claude with or without subagents
run_claude() {
    local prompt_file=$1
    local model=$2
    
    if [ "$USE_SUBAGENTS" == "true" ]; then
        cat "$prompt_file" | claude -p "$(cat -)" \
            --model "$model" \
            --agents "$(cat $SUBAGENTS_FILE)" \
            --dangerously-skip-permissions
    else
        cat "$prompt_file" | claude -p "$(cat -)" \
            --model "$model" \
            --dangerously-skip-permissions
    fi
}

# ============================================================================
# PHASE 0: SPECIFICATION GENERATION
# ============================================================================

phase0_spec_generation() {
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}  📋 PHASE 0: SPECIFICATION GENERATION                    ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$USE_SUBAGENTS" == "true" ]; then
        echo -e "${BLUE}Using parallel subagents for spec generation...${NC}"
    fi
    echo -e "${BLUE}Reading plan.md and generating specifications...${NC}"
    echo ""
    
    # Run spec generation with Sonnet (and subagents if available)
    run_claude "PROMPT_PHASE0_SPEC.md" "sonnet"
    
    if [ $? -eq 0 ]; then
        # Mark phase 0 complete
        set_phase "0-complete"
        
        echo ""
        echo -e "${GREEN}✅ Specifications generated!${NC}"
        echo ""
        echo -e "${YELLOW}📋 Please review the generated specs in specs/${NC}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo "  1. Review specs/ directory"
        echo "  2. Review fix_plan.md"
        echo "  3. Adjust if needed"
        echo "  4. Run: ./ralph.sh (to start implementation)"
        echo "  5. OR: ./ralph.sh --skip-review (to skip review)"
        echo ""
        
        # Commit specs
        git add -A
        git commit -m "Phase 0: Initial specifications generated by Ralph" || true
        
        if [ "$SKIP_REVIEW" != "true" ]; then
            exit 0
        else
            echo -e "${YELLOW}--skip-review enabled, continuing to implementation...${NC}"
            echo ""
            sleep 2
            set_phase "1"
        fi
    else
        echo -e "${RED}❌ Spec generation failed${NC}"
        exit 1
    fi
}

# ============================================================================
# PHASE 1: IMPLEMENTATION
# ============================================================================

phase1_implementation() {
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}  🔨 PHASE 1: IMPLEMENTATION                               ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$USE_SUBAGENTS" == "true" ]; then
        echo -e "${BLUE}Using subagents: Primary = Scheduler, Subagents = Workers${NC}"
    fi
    
    # Set initial model if not set
    if [ ! -f "$NEXT_MODEL_FILE" ]; then
        echo "sonnet" > "$NEXT_MODEL_FILE"
        echo "Initial implementation phase - using Sonnet" > "$MODEL_REASON_FILE"
    fi
    
    LOOP_COUNT=0
    
    while [ $LOOP_COUNT -lt $MAX_LOOPS ]; do
        LOOP_COUNT=$((LOOP_COUNT + 1))
        
        echo ""
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}🔄 Loop #$LOOP_COUNT - $(date '+%Y-%m-%d %H:%M:%S')${NC}"
        
        # Check if all TODOs are complete
        if ! grep -q "^- \[ \]" fix_plan.md 2>/dev/null; then
            echo ""
            echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║${NC}  🎉 ALL TODOS COMPLETE!                                   ${GREEN}║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo -e "${GREEN}✅ All tasks from fix_plan.md are complete${NC}"
            echo ""
            echo -e "${BLUE}Next steps:${NC}"
            echo "  • Review the implementation"
            echo "  • Test the application"
            echo "  • Run: ./ralph.sh --refine (for improvements)"
            echo ""
            
            set_phase "1-complete"
            git add -A
            git commit -m "Phase 1: Implementation complete" || true
            
            exit 0
        fi
        
        # Read model decision
        if [ -f "$NEXT_MODEL_FILE" ]; then
            MODEL=$(cat "$NEXT_MODEL_FILE" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
            REASON=$(cat "$MODEL_REASON_FILE" 2>/dev/null || echo "No reason")
        else
            MODEL="haiku"
            REASON="Fallback"
        fi
        
        # Validate model
        if [ "$MODEL" != "haiku" ] && [ "$MODEL" != "sonnet" ]; then
            MODEL="haiku"
            REASON="Invalid model corrected"
        fi
        
        # Log and count
        log_decision "$LOOP_COUNT" "$MODEL" "$REASON"
        
        if [ "$MODEL" == "haiku" ]; then
            HAIKU_COUNT=$((HAIKU_COUNT + 1))
            echo -e "⚡ ${GREEN}Using Haiku${NC}"
        else
            SONNET_COUNT=$((SONNET_COUNT + 1))
            echo -e "🧠 ${BLUE}Using Sonnet${NC}"
        fi
        
        echo -e "📝 Reason: $REASON"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        # Execute loop with subagents if available
        run_claude "PROMPT_PHASE1_IMPL.md" "$MODEL"
        
        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}⚠️  Error in loop - pausing 5 seconds...${NC}"
            sleep 5
        fi
        
        # Ensure model decision was made
        if [ ! -f "$NEXT_MODEL_FILE" ]; then
            echo -e "${YELLOW}⚠️  No model decision, defaulting to haiku${NC}"
            echo "haiku" > "$NEXT_MODEL_FILE"
            echo "Default - no decision made" > "$MODEL_REASON_FILE"
        fi
        
        sleep 1
        
        # Stats every 25 loops
        if [ $((LOOP_COUNT % 25)) -eq 0 ]; then
            echo ""
            echo -e "${BLUE}📊 Stats after $LOOP_COUNT loops:${NC}"
            echo -e "   ⚡ Haiku:  $HAIKU_COUNT ($(( HAIKU_COUNT * 100 / LOOP_COUNT ))%)"
            echo -e "   🧠 Sonnet: $SONNET_COUNT ($(( SONNET_COUNT * 100 / LOOP_COUNT ))%)"
            echo ""
            echo -e "${BLUE}📝 Recent commits:${NC}"
            git log --oneline -5
            echo ""
            sleep 10
        fi
    done
    
    echo -e "${YELLOW}⚠️  Max loops reached${NC}"
    exit 0
}

# ============================================================================
# PHASE 2: REFINEMENT
# ============================================================================

phase2_refinement() {
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}  ✨ PHASE 2: REFINEMENT & ENHANCEMENT                     ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$USE_SUBAGENTS" == "true" ]; then
        echo -e "${BLUE}Using subagents for parallel code analysis...${NC}"
    fi
    echo -e "${BLUE}Analyzing codebase for improvements...${NC}"
    echo ""
    
    # Run refinement analysis with Sonnet (and subagents if available)
    run_claude "PROMPT_PHASE2_REFINE.md" "sonnet"
    
    if [ $? -eq 0 ]; then
        set_phase "2"
        
        echo ""
        echo -e "${GREEN}✅ Refinement analysis complete${NC}"
        echo ""
        echo -e "${BLUE}Check fix_plan.md for new improvement tasks${NC}"
        echo ""
        echo "Run: ./ralph.sh (to implement refinements)"
        echo ""
        
        git add -A
        git commit -m "Phase 2: Refinement analysis - new improvements identified" || true
        
        exit 0
    else
        echo -e "${RED}❌ Refinement analysis failed${NC}"
        exit 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

# Parse arguments
SKIP_REVIEW=false
REFINE_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-review)
            SKIP_REVIEW=true
            shift
            ;;
        --refine)
            REFINE_MODE=true
            shift
            ;;
        --help)
            echo "Ralph Framework - Autonomous Development"
            echo ""
            echo "Usage: ./ralph.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-review    Skip spec review, go directly to implementation"
            echo "  --refine         Enter refinement mode (after todos complete)"
            echo "  --help           Show this help"
            echo ""
            echo "Phases:"
            echo "  Phase 0: Spec Generation (from plan.md)"
            echo "  Phase 1: Implementation (from specs)"
            echo "  Phase 2: Refinement (improvements beyond specs)"
            echo ""
            echo "Subagents:"
            echo "  If subagents.json exists, Ralph uses specialized subagents"
            echo "  for parallel operations and context management."
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run: ./ralph.sh --help"
            exit 1
            ;;
    esac
done

# Main execution
print_header
init_ralph
check_requirements

CURRENT_PHASE=$(get_phase)

echo -e "${BLUE}Current Phase: $CURRENT_PHASE${NC}"
if [ "$USE_SUBAGENTS" == "true" ]; then
    echo -e "${GREEN}Subagents: Enabled${NC}"
else
    echo -e "${YELLOW}Subagents: Disabled${NC}"
fi
echo ""

# Handle refine mode
if [ "$REFINE_MODE" == "true" ]; then
    if [ "$CURRENT_PHASE" != "1-complete" ]; then
        echo -e "${YELLOW}⚠️  Refinement mode requires Phase 1 to be complete${NC}"
        echo "Complete implementation first, then run: ./ralph.sh --refine"
        exit 1
    fi
    phase2_refinement
    exit 0
fi

# Phase routing
case $CURRENT_PHASE in
    0)
        # Phase 0: Generate specs
        phase0_spec_generation
        ;;
    0-complete)
        # Specs generated, move to implementation
        echo -e "${GREEN}Specs already generated, starting implementation...${NC}"
        set_phase "1"
        phase1_implementation
        ;;
    1|2)
        # Phase 1 or 2: Implementation
        phase1_implementation
        ;;
    1-complete)
        echo -e "${GREEN}✅ Implementation complete!${NC}"
        echo ""
        echo "Options:"
        echo "  • Review and test the application"
        echo "  • Run: ./ralph.sh --refine (for improvements)"
        exit 0
        ;;
    *)
        echo -e "${RED}Unknown phase: $CURRENT_PHASE${NC}"
        exit 1
        ;;
esac