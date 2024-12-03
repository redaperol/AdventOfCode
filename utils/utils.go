package main

import (
	"fmt"
	"io"
	"net/http"
)

func prout() {
	fmt.Println("prout")

}

func getwether(city string) string {
	url := "http://wether.in/" + city
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println("oups")
	}
	defer resp.Body.Close()
	answer, err := io.ReadAll(resp.Body)
	return string(answer)
}

func main() {
	wether := getwether("redon")
	fmt.Println(wether)
}
