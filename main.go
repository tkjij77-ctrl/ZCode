package main

import (
	"github.com/zcode-ai/zcode/cmd"
	"github.com/zcode-ai/zcode/internal/logging"
)

func main() {
	defer logging.RecoverPanic("main", func() {
		logging.ErrorPersist("Application terminated due to unhandled panic")
	})

	cmd.Execute()
}
