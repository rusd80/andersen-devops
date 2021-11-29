package main

import (
	"fmt"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

var botToken string

func main() {
	godotenv.Load(".env")
	botToken = os.Getenv("TOKEN")
	fmt.Println(botToken)
	err := http.ListenAndServe(":8090", http.HandlerFunc(webHookHandler))
	if err != nil {
		log.Fatal(err)
		return
	}
}
