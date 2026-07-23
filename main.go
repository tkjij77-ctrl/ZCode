package main

import (
	"github.com/tkjij77-ctrl/ZCode/cmd"
	"github.com/tkjij77-ctrl/ZCode/internal/logging"
)

func main() {
	defer logging.RecoverPanic("main", func() {
		logging.ErrorPersist("Application terminated due to unhandled panic")
	})

	cmd.Execute()
}
