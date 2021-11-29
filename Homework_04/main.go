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
)

func main() {
	loadErr := godotenv.Load(".env")
	if loadErr != nil {
		return
	}
	// get telegram bot token from .env
	botToken = os.Getenv("TOKEN")
	appPort = os.Getenv("PORT")
	err := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatal(err)
		return
	}
}
