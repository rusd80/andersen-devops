package main

type webHookReqBody struct {
	Message struct {
		Text string `json:"text"`
		Chat struct {
			ID int64 `json:"id"`
		} `json:"chat"`
	} `json:"message"`
}

type sendMessageReqBody struct {
	ChatID int64  `json:"chat_id"`
	Text   string `json:"text"`
}

//struct stores "names" and "URLs" of tasks done.
type homeWork struct {
	Name string `json:"name"`
	URL  string `json:"html_url"`
}
