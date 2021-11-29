package main

import (
	"fmt"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

var (
	botToken string
	appPort  string
)

func main() {
	godotenv.Load(".env")
	// get telegram bot token from .env
	botToken = os.Getenv("TOKEN")
	appPort = os.Getenv("PORT")
	fmt.Println(botToken, appPort)
	err := http.ListenAndServe(":"+appPort, http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatal(err)
		return
	}
}
