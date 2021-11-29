package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	re "regexp"
	"strings"
	"unicode"
)

var (
	apiUrl   string = "https://api.github.com/repos/rusd80/andersen-devops/contents"
	taskErr  string = "This homework is`nt done!"
	cmdErr   string = "Unknown command. Please try /help."
	taskList []homeWork
	response string
)

func webHookHandler(req *http.Request) {
	// Create our web hook request body type instance
	body := &webHookReqBody{}
	// Decodes the incoming request into our custom webhook req body type
	if err := json.NewDecoder(req.Body).Decode(body); err != nil {
		log.Printf("An error occured (webHookHandler)")
		log.Panic(err)
		return
	}
	// If the known command received call the sendReply function
	botMessage := strings.ToLower(body.Message.Text)
	if botMessage == "/tasks" || strings.HasPrefix(botMessage, "/task") {
		err := sendReply(body.Message.Chat.ID, body.Message.Text)
		if err != nil {
			log.Panic(err)
			return
		}
	}
}

func sendReply(chatID int64, command string) error {
	text, err := commandHandler(command)
	if err != nil {
		return err
	}
	//Creates an instance of our custom sendMessageReqBody Type
	reqBody := &sendMessageReqBody{
		ChatID: chatID,
		Text:   text,
	}
	// Convert our custom type into json format
	reqBytes, err := json.Marshal(reqBody)
	if err != nil {
		return err
	}
	// Make a request to send our message using the POST method to the telegram bot API
	resp, err := http.Post(
		"https://api.telegram.org/bot"+botToken+"/"+"sendMessage",
		"application/json",
		bytes.NewBuffer(reqBytes),
	)
	if err != nil {
		return err
	}
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
		}
	}(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return errors.New("unexpected status" + resp.Status)
	}
	return err
}

func fetchTasks() (string, error) {
	resp, getErr := http.Get(apiUrl)
	if getErr != nil {
		log.Fatal(getErr)
	}
	if resp.Body != nil {
		defer func(Body io.ReadCloser) {
			err := Body.Close()
			if err != nil {

			}
		}(resp.Body)
		decodeErr := json.NewDecoder(resp.Body).Decode(&taskList)
		if decodeErr != nil {
			log.Fatal(decodeErr)
		}
	}
	fmt.Println(len(taskList))
	for i := range taskList {
		fmt.Println(taskList[i].Name)
		fmt.Println(taskList[i])
	}
	response = "The next tasks are done ✅:\n"
	f := func(c rune) bool {
		return !unicode.IsLetter(c) && !unicode.IsNumber(c)
	}
	for i := range taskList {
		if strings.HasPrefix(taskList[i].Name, "Homework") {
			taskNum := strings.FieldsFunc(taskList[i].Name, f)[1]
			response += fmt.Sprintf("%d. %s", i+1, fmt.Sprintf("/task%s\n", taskNum))
		}
	}
	fmt.Println(response)
	return response, getErr
}

func commandHandler(command string) (string, error) {
	fmt.Println(command)
	switch command {
	case "/tasks":
		response, err := fetchTasks()
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println(response)
		return response, err
	default:
		pattern := re.MustCompile("/task([0-9]+)")
		if pattern.MatchString(command) {
			taskNumber := pattern.FindStringSubmatch(command)[1]
			fmt.Println(taskNumber)
			response = getTaskUrl(taskNumber)

		} else {
			response = cmdErr
		}
		return response, nil
	}
}

// Get_task_url retrieves a URL for a done homework
func getTaskUrl(taskNum string) string {
	var url string
	fmt.Println(taskNum)
	taskName := fmt.Sprintf("Homework_%s", taskNum)

	for i := range taskList {
		if taskList[i].Name == taskName {
			url = taskList[i].URL
			break
		}
	}
	if url == "" {
		url = taskErr
	}
	return url
}
