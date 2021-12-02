package main

import (
	"errors"
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

// function defines log file
func init() {
	logFile, err := os.Create("log.txt")
	if err != nil {
		log.Fatalln("can't create log.txt", err)
	}
	log.SetOutput(logFile)
}

// main function
func main() {
	loadErr := godotenv.Load(".env")
	if loadErr != nil {
		log.Fatalln("can`t load .env file content", loadErr)
	}
	// get telegram bot token from .env
	botToken = os.Getenv("TOKEN")
	appPort = os.Getenv("PORT")
	repo = os.Getenv("REPO")
	if botToken == "" || appPort == "" || repo == "" {
		err := errors.New(".env getenv method error")
		log.Fatalln("Can`t read required params from .env file", err)
		return
	} else {
		log.Println("Parameters from .env are read")
	}
	apiUrlContents = "https://api.github.com/repos" + repo + "/contents"
	apiUrlTopics = "https://api.github.com/repos" + repo + "/topics"
	apiUrlCommits = "https://api.github.com/repos" + repo + "/stats/participation"
	log.Println("Bot starting...")
	err := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatalln("Error of http listener", err)
		return
	}
}
