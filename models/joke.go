package models

import (
	"encoding/json"
	"os"
)

type Joke struct {
	Id       int    `json:"id"`
	Category string `json:"category"`
	Text     string `json:"text"`
}

func ReadJokes(jokesPath string) ([]Joke, error) {
	file, err := os.Open(jokesPath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var jokes []Joke
	decoder := json.NewDecoder(file)
	if err := decoder.Decode(&jokes); err != nil {
		return nil, err
	}
	return jokes, nil
}
