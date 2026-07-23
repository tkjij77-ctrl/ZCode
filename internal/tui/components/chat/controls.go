package chat

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
)

// ControlsBar represents the bottom bar from your design (Models, Power button, Mode)
type ControlsBar struct {
	ActiveModels []string
	CurrentMode  string // e.g., "Plan", "Work"
	IsActive     bool
}

// NewControlsBar creates a new bottom controls bar
func NewControlsBar() *ControlsBar {
	return &ControlsBar{
		ActiveModels: []string{"Claude (1)", "GPT-4 (2)"}, // Default models based on your idea
		CurrentMode:  "الوضع: العمل ⚡",
		IsActive:     true,
	}
}

// View renders the controls bar using Lipgloss (Bubble Tea styling)
func (c *ControlsBar) View(width int) string {
	// Base style for buttons
	btnStyle := lipgloss.NewStyle().
		Border(lipgloss.RoundedBorder()).
		BorderForeground(lipgloss.Color("#555555")).
		Padding(0, 1).
		Foreground(lipgloss.Color("#CCCCCC"))

	// Power button style
	powerStyle := btnStyle.Copy().
		BorderForeground(lipgloss.Color("#00FF00")).
		Foreground(lipgloss.Color("#00FF00")).
		Bold(true)

	// Build the buttons
	powerBtn := powerStyle.Render("القوة")
	addBtn := btnStyle.Render("+ أضف نموذج")
	
	// Build model buttons dynamically
	var modelBtns []string
	for _, m := range c.ActiveModels {
		modelBtns = append(modelBtns, btnStyle.Render(m))
	}
	
	// Mode button
	modeBtn := btnStyle.Render(c.CurrentMode)

	// Combine left side (Power, Add, Models)
	leftSideParts := append([]string{powerBtn, addBtn}, modelBtns...)
	leftSide := lipgloss.JoinHorizontal(lipgloss.Center, leftSideParts...)

	// Calculate spacing to push Mode button to the right
	leftWidth := lipgloss.Width(leftSide)
	rightWidth := lipgloss.Width(modeBtn)
	
	spacerWidth := width - leftWidth - rightWidth
	if spacerWidth < 0 {
		spacerWidth = 1
	}
	spacer := strings.Repeat(" ", spacerWidth)

	// Final bar
	bar := lipgloss.JoinHorizontal(lipgloss.Center, leftSide, spacer, modeBtn)
	
	return lipgloss.NewStyle().
		MarginTop(1).
		Render(bar)
}
