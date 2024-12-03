package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func sumArray(arr []int) int {
	res := 0
	for i := 0; i < len(arr); i++ {
		res += arr[i]
	}
	return res
}

func GetText(filePath string) []string {
	var result []string
	file, err := os.Open("input")
	if err != nil {
		fmt.Println("pas de bol")
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		result = append(result, line)
	}
	return result
}

func main() {
	StringToDo := GetText("testinput")
	reg := regexp.MustCompile(`mul\((\d{1,3}),(\d{1,3})\)`)
	var firstNumberArr []int
	var seconcdNumberArr []int
	for j := 0; j < len(StringToDo); j++ {
		matches := reg.FindAllStringSubmatch(StringToDo[j], 1000)
		for i := 0; i < len(matches); i++ {
			num1, err1 := strconv.Atoi(matches[i][1])
			num2, err2 := strconv.Atoi(matches[i][2])
			if err1 == nil && err2 == nil {
				firstNumberArr = append(firstNumberArr, num1)
				seconcdNumberArr = append(seconcdNumberArr, num2)
			} else {
				fmt.Println("Oups convert")
			}
		}
	}
	var resArr []int
	for i := 0; i < len(firstNumberArr); i++ {
		resArr = append(resArr, firstNumberArr[i]*seconcdNumberArr[i])
	}
	result := sumArray(resArr)
	fmt.Println("part 1 result : ", result)
}
