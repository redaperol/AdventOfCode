package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
)

func absnum(num int) int {
	if num >= 0 {
		return num
	} else {
		return num * -1
	}
}

func sumArray(arr []int) int {
	res := 0
	for i := 0; i < len(arr); i++ {
		res += arr[i]
	}
	return res
}

func main() {
	file, err := os.Open("input")
	if err != nil {
		fmt.Println("pas de bol")
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	reg := regexp.MustCompile(`(\d+)\s{3}(\d+)`)
	var firstNumberArr []int
	var seconcdNumberArr []int
	for scanner.Scan() {
		line := scanner.Text()
		matches := reg.FindStringSubmatch(line)
		if len(matches) == 3 {
			num1, err1 := strconv.Atoi(matches[1])
			num2, err2 := strconv.Atoi(matches[2])
			if err1 == nil && err2 == nil {
				firstNumberArr = append(firstNumberArr, num1)
				seconcdNumberArr = append(seconcdNumberArr, num2)
			} else {
				fmt.Println("Oups convert")
			}
		}
	}

	sort.Ints(firstNumberArr)
	sort.Ints(seconcdNumberArr)
	var difArr []int
	for i := 0; i < len(firstNumberArr); i++ {
		diffnum := firstNumberArr[i] - seconcdNumberArr[i]
		difArr = append(difArr, absnum(diffnum))
	}

	fmt.Println("Done calculatin number diff")
	fmt.Println("sum is ", sumArray(difArr))

	total := 0
	for i := 0; i < len(firstNumberArr); i++ {
		currentNum := firstNumberArr[i]
		occurence := 0
		for j := 0; j < len(seconcdNumberArr); j++ {
			if currentNum == seconcdNumberArr[j] {
				occurence++
			}
		}
		total += currentNum * occurence
	}
	fmt.Println("Done calculatin occurence")
	fmt.Println("sum is ", total)
}
