package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func StringToIntArr(stringArr []string) []int {
	var res = []int{}
	for i := 0; i < len(stringArr); i++ {
		a, err := strconv.Atoi(stringArr[i])
		if err != nil {
			fmt.Println("conversion error")
		}
		res = append(res, a)
	}
	return res
}

func toAbs(a int) int {
	if a < 0 {
		return a * -1
	} else {
		return a
	}
}

func testLevelMov(arr []int) bool {
	var DecreaseCount = 0
	var IncreaseCount = 0
	for i := 0; i < len(arr)-1; i++ {
		diff := arr[i] - arr[i+1]
		if diff > 0 {
			DecreaseCount++
		} else {
			IncreaseCount++
		}
	}
	if DecreaseCount == 0 || IncreaseCount == 0 {
		return true
	} else {
		return false
	}
}

func testLevelDiff(arr []int) bool {
	for i := 0; i < len(arr)-1; i++ {
		diff := arr[i] - arr[i+1]
		if diff == 0 {
			return false
		}
		if toAbs(diff) > 3 {
			return false
		}
	}
	return true
}

func isSafe(arr []int) bool {
	if testLevelMov(arr) && testLevelDiff(arr) {
		return true
	} else {
		return false
	}
}

func main() {
	file, err := os.Open("input")
	if err != nil {
		fmt.Println("pas de bol")
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	var NumberArr []int
	var safeCount = 0
	for scanner.Scan() {
		line := scanner.Text()
		lineArr := strings.Fields(line)
		NumberArr = StringToIntArr(lineArr)
		if isSafe(NumberArr) {
			safeCount++
		}
	}
	fmt.Println("NumberArr of safe", safeCount)
}
