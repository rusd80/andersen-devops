package main

import (
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

var (
	botToken       string // secret token of my telegram bot
	appPort        string // port that uses this app
	repo           string // repository on GitHub
	apiUrlContents string // full URL of GitHub API /contents
	apiUrlTopics   string // full URL of GitHub API /topics
	apiUrlCommits  string // full URL of GitHub API /statistics participation
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
	apiUrlContents = "https://api.github.com/repos" + repo + "/contents"
	apiUrlTopics = "https://api.github.com/repos" + repo + "/topics"
	apiUrlCommits = "https://api.github.com/repos" + repo + "/stats/participation"
	err := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatal(err)
		return
	}
}
