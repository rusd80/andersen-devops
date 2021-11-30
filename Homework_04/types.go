package main

// struct of webhook POST request
type webHookReqBody struct {
	Message struct {
		Text string `json:"text"`
		Chat struct {
			ID int64 `json:"id"`
		} `json:"chat"`
	} `json:"message"`
}

// struct of topics data
type allTopics struct {
	Names []string `json:"names"`
}

// struct of commit stats data
type commitStats struct {
	All []int `json:"all"`
}

// struct of message to send
type sendMessageReqBody struct {
	ChatID int64  `json:"chat_id"`
	Text   string `json:"text"`
}

//struct of HOMEWORK data: "names" and "URLs"
type homeWork struct {
	Name string `json:"name"`
	URL  string `json:"html_url"`
}
