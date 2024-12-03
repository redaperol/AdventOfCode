package main

import (
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

func fileToStrg(filepath string) (strg string) {
	buffer, err := os.ReadFile(filepath)
	if err != nil {
		fmt.Println("big oof")
	}
	strg = string(buffer)
	return strg
}

func parserInt(s string, regString string) (firstNumberArr []int, secondNumberArr []int) {
	regx := regexp.MustCompile(regString)

	match := regx.FindAllStringSubmatch(s, -1)

	for j := 0; j < len(match); j++ {
		num1, err1 := strconv.Atoi(match[j][1])
		num2, err2 := strconv.Atoi(match[j][2])

		if err1 == nil && err2 == nil {
			firstNumberArr = append(firstNumberArr, num1)
			secondNumberArr = append(secondNumberArr, num2)
		} else {
			fmt.Println("Oups convert")
		}
	}
	return firstNumberArr, secondNumberArr
}

func arrProduct(arr1, arr2 []int) (res int) {
	var resArr []int
	for i := 0; i < len(arr1); i++ {
		resArr = append(resArr, arr1[i]*arr2[i])
	}
	res = sumArray(resArr)
	return res
}

func searchAndDestroyString(strg string, reg string) string {
	var res string
	regToUse := regexp.MustCompile(reg)
	res = regToUse.ReplaceAllString(strg, "")
	return res
}

func main() {
	stringToDo := fileToStrg("input")
	firstArr, secondArr := parserInt(stringToDo, `mul\((\d{1,3}),(\d{1,3})\)`)
	fmt.Println("part 1 result : ", arrProduct(firstArr, secondArr))

	stringToDoPart2 := searchAndDestroyString(stringToDo, `don't\(\).*?(do\(\)|$|EOF|\n)`)
	firstArrPart2, secondArrPart2 := parserInt(stringToDoPart2, `mul\((\d{1,3}),(\d{1,3})\)`)
	fmt.Println("part 2 result : ", arrProduct(firstArrPart2, secondArrPart2))
}
