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
	// load .env file
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalln("can`t load .env file content", err)
	}
	// get telegram bot token, port, repo from .env
	botToken = os.Getenv("TOKEN")
	appPort = os.Getenv("PORT")
	repo = os.Getenv("REPO")
	// if there are not all data - error
	if botToken == "" || appPort == "" || repo == "" {
		dotEnvErr := errors.New(".env getenv method error")
		log.Fatalln("Can`t read required params from .env file", dotEnvErr)
	} else {
		log.Println("Parameters from .env are read")
	}
	// strings - URL's for GitHub API
	apiUrlContents = "https://api.github.com/repos" + repo + "/contents"
	apiUrlTopics = "https://api.github.com/repos" + repo + "/topics"
	apiUrlCommits = "https://api.github.com/repos" + repo + "/stats/participation"
	log.Println("Bot starting...")
	// http listener start
	httpErr := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if httpErr != nil {
		log.Fatalln("Error of http listener", httpErr)
	}
}
