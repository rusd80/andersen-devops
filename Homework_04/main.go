package main

import (
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

var (
	botToken string // secret token of my telegram bot
	appPort  string // port that uses this app
	repo     string // repository on GitHub
	apiUrl   string // full URL of GitHub API
)

// get topics
// get commit count
func main() {
	loadErr := godotenv.Load(".env")
	if loadErr != nil {
		return
	}
	// get telegram bot token from .env
	botToken = os.Getenv("TOKEN")
	appPort = os.Getenv("PORT")
	repo = os.Getenv("REPO")
	if botToken == "" || appPort == "" || repo == "" {
		log.Fatal("Can`t read .env file")
		return
	}
	apiUrl = "https://api.github.com/repos" + repo + "/contents"
	err := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatal(err)
		return
	}
}
