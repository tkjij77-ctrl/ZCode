package agent

import (
	"context"
	"fmt"
	"strings"

	"github.com/tkjij77-ctrl/ZCode/internal/llm/provider"
	"github.com/tkjij77-ctrl/ZCode/internal/message"
)

// TaskType defines the role of a sub-agent
type TaskType string

const (
	TaskTypePlan   TaskType = "Planner"
	TaskTypeCode   TaskType = "Coder"
	TaskTypeReview TaskType = "Reviewer"
)

// SubAgent represents a specialized AI agent in our multi-agent system
type SubAgent struct {
	Role        TaskType
	ModelName   string
	Provider    provider.Provider
	SystemIntro string
}

// ManagerAgent orchestrates the multi-agent workflow
type ManagerAgent struct {
	Planner  *SubAgent
	Coder    *SubAgent
	Reviewer *SubAgent
}

// NewManagerAgent creates a new orchestration manager with specialized roles
func NewManagerAgent(plannerProv, coderProv, reviewerProv provider.Provider, planModel, codeModel, reviewModel string) *ManagerAgent {
	return &ManagerAgent{
		Planner: &SubAgent{
			Role:      TaskTypePlan,
			Provider:  plannerProv,
			ModelName: planModel,
			SystemIntro: "You are the Architect Planner. Your job is to break down the user's project request into logical, manageable steps. Do not write code. Output a clear step-by-step plan.",
		},
		Coder: &SubAgent{
			Role:      TaskTypeCode,
			Provider:  coderProv,
			ModelName: codeModel,
			SystemIntro: "You are the Expert Coder. You will receive a plan and must write clean, optimized code for it. Focus purely on implementation.",
		},
		Reviewer: &SubAgent{
			Role:      TaskTypeReview,
			Provider:  reviewerProv,
			ModelName: reviewModel,
			SystemIntro: "You are the QA Reviewer. Review the provided code, find bugs, security issues, and suggest improvements. If it's perfect, say 'APPROVED'.",
		},
	}
}

// ExecuteProject takes a user request and runs it through the Multi-Agent pipeline
func (m *ManagerAgent) ExecuteProject(ctx context.Context, userPrompt string, updateUI func(status string)) (string, error) {
	updateUI("🧠 [Manager] Analyzing the project requirements...")

	// Step 1: Planning (e.g., using GPT-4 or reasoning model)
	updateUI(fmt.Sprintf("📝 [Planner - %s] Creating project blueprint...", m.Planner.ModelName))
	plan, err := m.runSubAgent(ctx, m.Planner, userPrompt)
	if err != nil {
		return "", fmt.Errorf("planning failed: %v", err)
	}

	// Step 2: Coding (e.g., using Claude 3.5 Sonnet)
	updateUI(fmt.Sprintf("💻 [Coder - %s] Writing code based on blueprint...", m.Coder.ModelName))
	coderPrompt := fmt.Sprintf("Here is the user request: %s\n\nHere is the plan to follow:\n%s", userPrompt, plan)
	code, err := m.runSubAgent(ctx, m.Coder, coderPrompt)
	if err != nil {
		return "", fmt.Errorf("coding failed: %v", err)
	}

	// Step 3: Reviewing (e.g., using Gemini or another model)
	updateUI(fmt.Sprintf("🔍 [Reviewer - %s] Testing and reviewing code...", m.Reviewer.ModelName))
	reviewerPrompt := fmt.Sprintf("Review the following code based on the user request: %s\n\nCode:\n%s", userPrompt, code)
	review, err := m.runSubAgent(ctx, m.Reviewer, reviewerPrompt)
	if err != nil {
		return "", fmt.Errorf("reviewing failed: %v", err)
	}

	updateUI("✅ [Manager] Project completed successfully!")
	
	finalOutput := fmt.Sprintf("### Project Plan ###\n%s\n\n### Executed Code ###\n%s\n\n### Code Review ###\n%s", plan, code, review)
	return finalOutput, nil
}

// runSubAgent is a helper to run a specific model with a specific system prompt
func (m *ManagerAgent) runSubAgent(ctx context.Context, agent *SubAgent, prompt string) (string, error) {
	// In a real implementation, this would call agent.Provider.Complete(ctx, messages)
	// For now, this is the architectural skeleton linking the multi-agent system
	
	// Create the message payload
	msgs := []message.Message{
		{Role: message.RoleSystem, Content: []message.Content{{Type: message.ContentTypeText, Text: agent.SystemIntro}}},
		{Role: message.RoleUser, Content: []message.Content{{Type: message.ContentTypeText, Text: prompt}}},
	}
	
	_ = msgs // Suppress unused error for the skeleton

	// Placeholder for the actual API call logic to the specific provider
	// response, err := agent.Provider.Chat(ctx, agent.ModelName, msgs)
	
	return fmt.Sprintf("[Output from %s - %s simulated]", agent.Role, agent.ModelName), nil
}
