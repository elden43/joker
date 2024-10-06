package config

import "os"

type Config struct {
	Port      string
	JokesPath string
}

func New() Config {
	return Config{
		Port:      getEnv("APP_PORT", "8090"),
		JokesPath: getEnv("JOKES_PATH", "data/jokes.json"),
	}
}

func getEnv(key, defaultValue string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		return defaultValue
	}
	return value
}
